angular.module "comap" <[config]>
.factory CoMapData: <[$http API_ENDPOINT]> ++ ($http, API_ENDPOINT) ->
  get: (key) ->
    $http.get "#API_ENDPOINT/collections/booth/#key"
  random: (county, count) ->
    $http.get "#API_ENDPOINT/collections/booth" do
      params:
        q: JSON.stringify {lat: null}
        f: JSON.stringify {+id}
        l: 1
        sk: Math.round Math.random! * count
  count: (county, q) ->
    $http.get "#API_ENDPOINT/collections/booth" do
      params:
        q: q
        c: 1
  set: (key, data) ->
    $http.put "#API_ENDPOINT/collections/booth/#key", data
  geocode: (query, {city, country = "TW"}) ->
    $http.get 'https://nominatim.openstreetmap.org/search' do
      params: {city, country} <<< do
        format: 'json'
        addressdetails: 1
        street: query

.controller CoMapCtrl: <[$scope $sce $materialSidenav $state leafletData CoMapData]> ++ ($scope, $sce, $materialSidenav, $state, leafletData, CoMapData) ->
  $scope.county-name = city = "新北市"

  $scope.$watch '$state.params.county' -> if it
    res <- CoMapData.count it, JSON.stringify {lat: null} .success
    $scope.count = res.count
    res <- CoMapData.count it .success
    $scope.total = res.count
    if $state.current.name is 'comap.county'
      $scope.random!

  $scope.$watch '$state.params.seq' -> if it
    $scope.id = "#{$state.params.county}-#{$state.params.seq}"
    $scope.data <- CoMapData.get $scope.id .success
    $scope.osmdata = if $scope.data.osm_data => that else {} <<< $scope.data{place_name, address}
    if $scope.data.osm_id
      $scope.show-osm that

  $scope.toggleLeft = ->
    $materialSidenav('left').toggle()

  $scope <<< do
    center: do
      lat: 24.5
      lng: 121.5
      zoom: 8
  map <- leafletData.getMap!then

  $scope.find = (what, force) ->
    CoMapData.geocode $scope.osmdata.place_name, {city} .success (res) ->
      $scope.osmdata.name-results = res
    CoMapData.geocode $scope.osmdata.address, {city} .success (res) ->
      $scope.osmdata.address-results = res
    if $scope.data.street
      CoMapData.geocode $scope.osmdata.street, {city} .success (res) ->
        $scope.osmdata.street-results = res
  $scope.edit = (entry) ->
    edit_url = "https://www.openstreetmap.org/edit?#{entry.osm_type}=#{entry.osm_id}"
    window.open edit_url, '_blank'
  $scope.setPlace = (entry) ->
    $scope.data <<< entry{place_id} <<< do
      osm_id: "#{entry.osm_type}/#{entry.osm_id}"
      lat: entry.lat
      lng: entry.lon
      osm_name: $('tag[k="name"]', $scope.xml).attr("v")
    <- $scope.show-osm $scope.data.osm_id
    $scope.dirty = true
    $scope.selectingName = false

  $scope.setStreet = (entry) ->
    $scope.data <<< do
      osm_street_id: "#{entry.osm_type}/#{entry.osm_id}"
    <- $scope.show-osm $scope.data.osm_street_id
    $scope.dirty = true
    $scope.selectingAddress = false

  $scope.save = ->
    $scope.data.osm_data = $scope.osmdata
    <- CoMapData.set $scope.id, $scope.data{osm_data,place_id,osm_id,osm_name,lat,lng,osm_street_id} .success
    $scope.dirty = false
    $scope.random!

  $scope.random = ->
    data <- CoMapData.random $scope.county, $scope.count .success
    $scope.count = data.paging.count
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

.controller LeftCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('left').close()

.controller RightCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('right').close()
