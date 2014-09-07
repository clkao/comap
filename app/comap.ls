angular.module "comap" []
.factory CoMapData: <[$http]> ++ ($http) ->
  get: (key) ->
    return [
      # mocked for now
      * id: "TPQ-2153"
        name: "青潭國小"
        address: "北宜路二段８０號"
        village: "美潭里"
        remark: "1-7,9"
        osmdata: do
          name: "青潭國小"
          address: "80 北宜路二段"
      * id: "TPQ-2150"
        name: "格頭市民活動中心"
        address: "北宜路五段３號"
        village: "格頭里"
        remark: "全里"
      * id: "TPQ-2179"
        name: "瑞芳國小"
        address: "中山路２號"
        village: "龍潭里"
        remark: "全里"
        place_id: 87179326
        osm_id: "way/156133370"
    ]
  geocode: (query, {city, country = "TW"}) ->
    $http.get 'https://nominatim.openstreetmap.org/search' do
      params: {city, country} <<< do
        format: 'json'
        addressdetails: 1
        street: query

.controller CoMapCtrl: <[$scope $sce $materialSidenav leafletData CoMapData]> ++ ($scope, $sce, $materialSidenav, leafletData, CoMapData) ->
  $scope.toggleLeft = ->
    $materialSidenav('left').toggle()

  $scope <<< do
    center: do
      lat: 24.5
      lng: 121.5
      zoom: 8
    default:
      tileLayer: "http://{s}.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png"
      maxZoom: 14
      path:
        weight: 10
        color: '#800000'
        opacity: 1
  $scope.data = CoMapData.get 'TPQ' .0
  $scope.osmdata = if $scope.data.osmdata => that else {} <<< $scope.data
  map <- leafletData.getMap!then


  city = "新北市"
  $scope.find = ->
    CoMapData.geocode $scope.osmdata.name, {city} .success (res) ->
      for i in res
        i.edit_url = $sce.trustAsResourceUrl "https://www.openstreetmap.org/edit?#{i.osm_type}=#{i.osm_id}"
      $scope.name-results = res
    CoMapData.geocode $scope.osmdata.address, {city} .success (res) ->
      $scope.address-results = res
    if $scope.data.street
      CoMapData.geocode $scope.osmdata.street, {city} .success (res) ->
        $scope.street-results = res
  #L.mapbox.accessToken = 'pk.eyJ1IjoiY2xrYW8iLCJhIjoiOW5MUkJEOCJ9.xOaCu48ToZJa7h2sxcH_SA';
  #mapboxTiles = L.tileLayer 'https://{s}.tiles.mapbox.com/v3/clkao.j69d46c1/{z}/{x}/{y}.png', do
  #  attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
  #map.addLayer mapboxTiles

  var active-layer
  show-osm = (osm_id) ->
    full = if osm_id is /node/ => "" else "/full"
    $.ajax do
      url: "https://www.openstreetmap.org/api/0.6/#{osm_id}#{full}"
      dataType: "xml"
      success: (xml) ->
        map.remove-layer that if active-layer
        layer = new L.OSM.DataLayer xml
        map.fit-bounds layer.get-bounds!
        <- set-timeout _, 1000ms
        layer.add-to map
        active-layer := layer

  if $scope.data.osm_id
    show-osm that
  $scope.look = (entry) ->
    show-osm entry<[osm_type osm_id]>.join '/'

.controller LeftCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('left').close()

.controller RightCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('right').close()
