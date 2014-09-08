angular.module "comap" <[config]>
.factory CoMapData: <[$http API_ENDPOINT]> ++ ($http, API_ENDPOINT) ->
  get: (key) ->
    $http.get "#API_ENDPOINT/collections/booth/#key"
  set: (key, data) ->
    console.log \toset
    $http.put "#API_ENDPOINT/collections/booth/#key", data
  geocode: (query, {city, country = "TW"}) ->
    $http.get 'https://nominatim.openstreetmap.org/search' do
      params: {city, country} <<< do
        format: 'json'
        addressdetails: 1
        street: query

.controller CoMapCtrl: <[$scope $sce $materialSidenav $state leafletData CoMapData]> ++ ($scope, $sce, $materialSidenav, $state, leafletData, CoMapData) ->
  city = "新北市"

  $scope.$watch '$state.current.name' ->
    console.log \woot $state
  $scope.$watch '$state.params.seq' -> if it
    $scope.id = "#{$state.params.county}-#{$state.params.seq}"
    console.log \woot $scope.id
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

  $scope.find = ->
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

  $scope.save = ->
    $scope.data.osm_data = $scope.osmdata
    <- CoMapData.set $scope.id, $scope.data{osm_data,place_id,osm_id,osm_name,lat,lng}

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
