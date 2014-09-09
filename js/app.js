function import$(t,o){var e={}.hasOwnProperty;for(var n in o)e.call(o,n)&&(t[n]=o[n]);return t}require.register("config.jsenv",function(t,o,e){e.exports={BUILD:"git-7d83ba8"}}),angular.module("App",["app.templates","ngMaterial","ui.router","comap","leaflet-directive"]).config(["$stateProvider","$urlRouterProvider","$locationProvider"].concat(function(t,o,e){return t.state("about",{url:"/about",templateUrl:"app/partials/about.html",controller:"About"}).state("comap",{url:"/comap",templateUrl:"app/partials/comap.html",controller:"CoMapCtrl"}).state("comap.county",{url:"/{county}"}).state("comap.county.booth",{url:"/{seq}"}),o.otherwise("/comap/TPQ"),e.html5Mode(!0)})).run(["$rootScope","$state","$stateParams","$location","$window","$anchorScroll"].concat(function(t,o,e,n){return t.$state=o,t.$stateParam=e,t.config_build=require("config.jsenv").BUILD,t.$on("$stateChangeSuccess",function(t,o){var e;return e=o.name,"undefined"!=typeof window&&null!==window&&"function"==typeof window.ga?window.ga("send","pageview",{page:n.$$path,title:e}):void 0})})).controller({AppCtrl:["$scope","$location","$rootScope","$sce"].concat(function(t,o){return t.$location=o,t.$watch("$location.path()",function(o){return o||(o="/"),t.activeNavId=o,t}),t.getClass=function(o){return t.activeNavId.substring(0,o.length===o)?"active":""}})}).controller({About:["$rootScope","$http"].concat(function(t){return t.activeTab="about"})}),angular.module("config",[]).constant("API_ENDPOINT","http://api-beta.ly.g0v.tw:3908"),angular.module("comap",["config"]).factory({CoMapData:["$http","API_ENDPOINT"].concat(function(t,o){return{get:function(e){return t.get(o+"/collections/booth/"+e)},random:function(e,n){return t.get(o+"/collections/booth",{params:{q:JSON.stringify({lat:null}),f:JSON.stringify({id:!0}),l:1,sk:Math.round(Math.random()*n)}})},count:function(e,n){return t.get(o+"/collections/booth",{params:{q:n,c:1}})},set:function(e,n){return t.put(o+"/collections/booth/"+e,n)},geocode:function(o,e){var n,a,r,c;return n=e.city,a=null!=(r=e.country)?r:"TW",c=e.county,t.get("https://nominatim.openstreetmap.org/search",{params:import$({county:c,city:n,country:a},{format:"json",addressdetails:1,street:o})})}}})}).controller({CoMapCtrl:["$scope","$sce","$materialSidenav","$state","leafletData","CoMapData"].concat(function(t,o,e,n,a,r){var c;return t.$watch("$state.params.county",function(o){return o?(t.countyName=c={TPQ:"新北市",TPE:"臺北市"}[o],r.count(o,JSON.stringify({lat:null})).success(function(e){return t.count=e.count,r.count(o).success(function(o){return t.total=o.count,"comap.county"===n.current.name?t.random():void 0})})):void 0}),t.$watch("$state.params.seq",function(o){return o?(t.id=n.params.county+"-"+n.params.seq,r.get(t.id).success(function(o){var e,n,a;return t.data=o,t.osmdata=(e=t.data.osm_data)?e:(a={},a.place_name=(n=t.data).place_name,a.address=n.address,a),(e=t.data.osm_id)?t.showOsm(e):void 0})):void 0}),t.toggleLeft=function(){return e("left").toggle()},import$(t,{center:{lat:24.5,lng:121.5,zoom:8}}),a.getMap().then(function(o){var e;return t.edit=function(t){var o;return o="https://www.openstreetmap.org/edit?"+t.osm_type+"="+t.osm_id,window.open(o,"_blank")},t.setPlace=function(o){var e;return import$((e=t.data,e.place_id=o.place_id,e),{osm_id:o.osm_type+"/"+o.osm_id,lat:o.lat,lng:o.lon,osm_name:$('tag[k="name"]',t.xml).attr("v")}),t.showOsm(t.data.osm_id,function(){return t.dirty=!0,t.selectingName=!1})},t.selectName=function(o){return(o||!t.osmdata.nameResults)&&r.geocode(t.osmdata.place_name,{city:c}).success(function(o){return t.osmdata.nameResults=o}),t.selectingName=!0},t.selectAddress=function(o){return(o||!t.osmdata.addressResults)&&r.geocode(t.osmdata.address,{city:c,county:t.data.town}).success(function(o){return t.osmdata.addressResults=o}),t.selectingAddress=!0},t.setStreet=function(o){return import$(t.data,{osm_street_id:o.osm_type+"/"+o.osm_id}),t.showOsm(t.data.osm_street_id,function(){return t.dirty=!0,t.selectingAddress=!1})},t.save=function(){var o;return t.data.osm_data=t.osmdata,r.set(t.id,{osm_data:(o=t.data).osm_data,place_id:o.place_id,osm_id:o.osm_id,osm_name:o.osm_name,lat:o.lat,lng:o.lng,osm_street_id:o.osm_street_id}).success(function(){return t.dirty=!1,t.random()})},t.random=function(){return r.random(t.county,t.count).success(function(o){var e,a,r;return t.count=o.paging.count,e=o.entries[0].id.split("-"),a=e[0],r=e[1],n.transitionTo("comap.county.booth",{county:n.params.county,seq:r})})},t.showOsm=function(n,a){var r;return r=/node/.exec(n)?"":"/full",$.ajax({url:"https://www.openstreetmap.org/api/0.6/"+n+r,dataType:"xml",success:function(n){var r,c;return t.xml=n,"function"==typeof a&&a(),(r=e)&&o.removeLayer(r),c=new L.OSM.DataLayer(n),o.fitBounds(c.getBounds()),setTimeout(function(){return c.addTo(o),e=c},200)}})},t.look=function(o){return t.showOsm([o.osm_type,o.osm_id].join("/"))}})})}).controller({LeftCtrl:["$scope","$timeout","$materialSidenav"].concat(function(t,o,e){return t.close=function(){return e("left").close()}})}).controller({RightCtrl:["$scope","$timeout","$materialSidenav"].concat(function(t,o,e){return t.close=function(){return e("right").close()}})});