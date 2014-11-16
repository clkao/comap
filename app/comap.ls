tw3166 = do
  CHA: "彰化縣"
  CYI: "嘉義市"
  CYQ: "嘉義縣"
  HSQ: "新竹縣"
  HSZ: "新竹市"
  HUA: "花蓮縣"
  ILA: "宜蘭縣"
  JME: "金門縣"
  KEE: "基隆市"
  KHH: "高雄市"
  LJF: "連江縣"
  MIA: "苗栗縣"
  NAN: "南投縣"
  PEN: "澎湖縣"
  PIF: "屏東縣"
  TAO: "桃園市"
  TNN: "臺南市"
  TPE: "臺北市"
  TPQ: "新北市"
  TTT: "臺東縣"
  TXG: "臺中市"
  YUN: "雲林縣"

angular.module "comap" <[config]>
.factory CoMapData: <[$http API_ENDPOINT]> ++ ($http, API_ENDPOINT) ->
  get: (key) ->
    $http.get "#API_ENDPOINT/collections/booth/#key"
  random: (county, count) ->
    $http.get "#API_ENDPOINT/collections/booth" do
      params:
        q: JSON.stringify {county, lat: null}
        f: JSON.stringify {+id}
        l: 1
        sk: Math.round Math.random! * count
  count: (county, q = {}) ->
    $http.get "#API_ENDPOINT/collections/booth" do
      params:
        q: JSON.stringify {county} <<< q
        c: 1
  completion: ->
    $http.get "#API_ENDPOINT/collections/completion"

  set: (key, data) ->
    $http.put "#API_ENDPOINT/collections/booth/#key", data
  geocode: ({q, house_number, street, city, country = "TW", county}) ->
    # crazy osm special case before the admin region actually changes
    if city is '桃園市'
      city = '桃園縣 (Táoyuán)'
    $http.get 'https://nominatim.openstreetmap.org/search' do
      params: {county, city, country} <<< do
        format: 'json'
        addressdetails: 1
        street: "#house_number #street"
        q: q

.controller CoMapCtrl: <[$q $scope $sce $state leafletData CoMapData]> ++ ($q, $scope, $sce, $state, leafletData, CoMapData) ->
  var city

  count = $q.defer!
  $scope.$watch '$state.params.county' -> if it
    $scope.county = it
    $scope.county-name = city := tw3166[it]
    res <- CoMapData.count it, {lat: null} .success
    $scope.count = res.count
    res <- CoMapData.count it .success
    $scope.total = res.count
    count.resolve!
    if $state.current.name is 'comap.county'
      $scope.random!

  $scope <<< do
    center: do
      lat: 25.04
      lng: 121.54
      zoom: 13
  map <- leafletData.getMap!then

  $scope.match = (entry) ->
    $scope.data <<< do
      osm_id: entry.osm_id
      lat: entry.lat
      lng: entry.lon

  $scope.search = ->
    $scope.osmdata.search-results = [];
    CoMapData.geocode {city, county: $scope.data.town, q: $scope.osmdata.place_name} .success (res) ->
      $scope.osmdata.search-results ++= res
    CoMapData.geocode {city, county: $scope.data.town, house_number: $scope.osmdata.house_number, street: $scope.osmdata.address} .success (res) ->
      $scope.osmdata.search-results ++= res

  $scope.save = ->
    $scope.data.osm_data = $scope.osmdata
    <- CoMapData.set $scope.id, $scope.data{osm_data,place_id,osm_id,osm_name,lat,lng,osm_street_id} .success
    $scope.dirty = false
    $scope.random!

  $scope.random = ->
    data <- CoMapData.random $scope.county, $scope.count .success
    [_, seq] = data.entries.0.id.split '-'
    $state.transition-to 'comap.county.booth' {county: $state.params.county, seq}

  #L.mapbox.accessToken = 'pk.eyJ1IjoiY2xrYW8iLCJhIjoiOW5MUkJEOCJ9.xOaCu48ToZJa7h2sxcH_SA';
  #mapboxTiles = L.tileLayer 'https://{s}.tiles.mapbox.com/v3/clkao.j69d46c1/{z}/{x}/{y}.png', do
  #  attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
  #map.addLayer mapboxTiles

  var active-layer
  $scope.show-osm = (osm_id, cb) ->
    full = if osm_id is /node/ => "" else "/full"
    $.ajax do
      url: "https://www.openstreetmap.org/api/0.6/#{osm_id}#{full}"
      dataType: "xml"
      success: (xml) ->
        $scope.xml = xml
        cb?!
        map.remove-layer that if active-layer
        layer = new L.OSM.DataLayer xml
        map.fit-bounds layer.get-bounds!
        <- set-timeout _, 200ms
        layer.add-to map
        active-layer := layer

  $scope.look = (entry) ->
    $scope.show-osm entry<[osm_type osm_id]>.join '/'

  $scope.search-results-filter = (entry) ->
    if $scope.data.osm_id
      if $scope.data.osm_id == entry.osm_id
        $scope.look entry
        true
      else
        false
    else
      true

  $scope.$watch '$state.params.seq' -> unless it is undefined
    unless it
      return count.promise.then -> $scope.random!
    $scope.id = "#{$state.params.county}-#{$state.params.seq}"
    $scope.data <- CoMapData.get $scope.id .success
    $scope.osmdata = if $scope.data.osm_data => that else {} <<< $scope.data{place_name, address}

.filter "countyName" -> (county) -> tw3166[county]
