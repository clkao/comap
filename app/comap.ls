angular.module "comap" []
.controller CoMapCtrl: <[$scope $materialSidenav leafletData]> ++ ($scope, $materialSidenav, leafletData) ->
  console.log \hi
  $scope.toggleLeft = ->
    $materialSidenav('left').toggle()
  $scope.toggleRight = ->
    $materialSidenav('right').toggle()

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
  map <- leafletData.getMap!then
  console.log \woot map
#  map.fitBounds [40.712, -74.227], [40.774, -74.125]
  $.ajax do
    url: "https://www.openstreetmap.org/api/0.6/relation/2922120/full",
    dataType: "xml",
    success: (xml) ->
      layer = new L.OSM.DataLayer xml
      map.fit-bounds layer.get-bounds!
      <- set-timeout _, 1000ms
      layer.add-to map
      window.layer = layer
      window.map = map




.controller LeftCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('left').close()

.controller RightCtrl: <[$scope $timeout $materialSidenav]> ++ ($scope, $timeout, $materialSidenav) ->
  $scope.close = -> $materialSidenav('right').close()
