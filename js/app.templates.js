angular.module("app.templates", []).run(["$templateCache", function($templateCache) {$templateCache.put("app/partials/about.html","<material-content class=\"material-content-padding about-content\"><h2>鄉民 Geocode</h2><p>把頭開票所標在 OpenStreetMap 上</p><h3>資料來源</h3><a href=\"https://github.com/g0v/cec/tree/master/2014/booth\">各縣市選舉委員會</a><h3>Geocoding</h3><p>Geocoding is powered by<a href=\"http://wiki.openstreetmap.org/wiki/Nominatim\">Nominatim</a></p></material-content>");
$templateCache.put("app/partials/comap.html","<section layout=\"horizontal\" layout-fill=\"layout-fill\"><material-sidenav component-id=\"left\" class=\"material-sidenav-left material-whiteframe-z2\"><material-content ng-controller=\"LeftCtrl\" class=\"material-content-padding\"><material-button ng-click=\"close()\" hide-md=\"hide-md\" class=\"material-button-colored\">Close Sidenav Left</material-button><material-list><material-item><div class=\"material-tile-content\"><div ng-style=\"{width: \'28%\'}\" class=\"ui top attached progress successful\"><div class=\"bar\"></div></div><h2 title=\"28%\">臺北市 (2358)</h2></div></material-item><material-item><div class=\"material-tile-content\"><div ng-style=\"{width: \'18%\'}\" class=\"ui top attached progress successful\"><div class=\"bar\"></div></div><h2 title=\"18%\">新北市 (2947)</h2></div></material-item></material-list></material-content></material-sidenav><material-content layout-fill=\"layout-fill\"><div layout=\"vertical\" layout-fill=\"layout-fill\" layout-align=\"center center\"><material-toolbar scroll-shrink=\"scroll-shrink\" class=\"material-theme-green\"><div class=\"material-toolbar-tools\"><material-button ng-click=\"toggleLeft()\" hide-md=\"hide-md\" class=\"material-theme-light-blue material-button-raised\"><i class=\"list icon\"></i></material-button><h1>{{ countyName }} ({{ (total - count) / total * 100 | number:2}}%) / {{data.town}}{{ data.village }} / {{ id }} 投開票所</h1><material-button ng-click=\"save()\" ng-show=\"dirty\" class=\"material-button-raised material-button-colored material-theme-red\">Save</material-button><material-button ng-click=\"random()\" layout-align=\"end\" class=\"material-button-raised material-button-colored material-theme-orange\">Random</material-button></div></material-toolbar><div layout=\"horizontal\" layout-fill=\"layout-fill\" flex=\"flex\" layout-align=\"center\"><material-content layout=\"vertical\" flex=\"flex\" class=\"material-content-padding comap-input\"><material-card layout-fill=\"layout-fill\" flex=\"flex\"><h3>{{ data.place_name }}</h3><material-input-group><label for=\"place_name\">Place Name</label><section layout=\"horizontal\"><material-input id=\"place_name\" type=\"text\" ng-model=\"osmdata.place_name\"></material-input><i ng-show=\"data.osm_id\" class=\"circular teal inverted checkmark icon\"></i><i ng-hide=\"data.osm_id\" ng-click=\"selectName()\" class=\"circular red inverted question icon\"></i></section></material-input-group><material-whiteframe layout=\"vertical\" layout-align=\"left center\" ng-show=\"selectingName\" class=\"material-whiteframe-z2 fixed\"><material-content class=\"material-content-padding\"><div layout=\"horizontal\" layout-align=\"end\"><material-button ng-click=\"selectName(1)\">Query Again</material-button><material-button ng-click=\"selectingName = false\">close</material-button></div><div ng-if=\"osmdata.nameResults &amp;&amp; osmdata.nameResults.length == 0\">No results</div><material-list ng-if=\"osmdata.nameResults\"><material-item ng-repeat=\"entry in osmdata.nameResults\"><div class=\"material-tile-left\"><i class=\"circular icon\"><img ng-src=\"{{entry.icon}}\"/></i></div><div class=\"material-tile-content\"><i ng-click=\"look(entry)\" class=\"circular icon zoom in\"></i><i ng-click=\"edit(entry)\" class=\"circular icon edit\"></i><i ng-click=\"setPlace(entry)\" ng-class=\"{teal: data.osm_id == entry.osm_type + \'/\' + entry.osm_id}\" class=\"circular icon checkmark\"></i><h2>{{entry.display_name}}</h2></div></material-item></material-list></material-content></material-whiteframe><material-input-group><label for=\"place_remark\">Remark</label><material-input id=\"place_remark\" type=\"text\" ng-model=\"osmdata.place_remark\" size=\"6\"></material-input></material-input-group></material-card><material-card layout-fill=\"layout-fill\" flex=\"flex\"><h3>{{ data.address }}</h3><material-input-group><label for=\"address\">Address</label><section layout=\"horizontal\"><material-input id=\"test\" type=\"text\" ng-model=\"osmdata.address\"></material-input><i ng-show=\"data.osm_street_id\" class=\"circular teal inverted checkmark icon\"></i><i ng-hide=\"data.osm_street_id\" ng-click=\"selectAddress()\" class=\"circular red inverted question icon\"></i></section></material-input-group><material-input-group><label for=\"house_number\">Number</label><section layout=\"horizontal\"><material-input id=\"test\" type=\"text\" ng-model=\"osmdata.house_number\" size=\"6\"></material-input><!--i.circular.teal.checkmark.icon(ng-show=\"data.osm_street_id\")--></section></material-input-group><material-whiteframe layout=\"vertical\" layout-align=\"left center\" ng-show=\"selectingAddress\" class=\"material-whiteframe-z2 fixed\"><material-content class=\"material-content-padding\"><div ng-if=\"osmdata.addressResults &amp;&amp; osmdata.addressResults.length == 0\">No results</div><material-list ng-if=\"osmdata.addressResults\"><material-item ng-repeat=\"entry in osmdata.addressResults\"><div class=\"material-tile-content\"><i ng-click=\"look(entry)\" class=\"circular icon zoom in\"></i><i ng-click=\"edit(entry)\" class=\"circular icon edit\"></i><i ng-click=\"setStreet(entry)\" ng-class=\"{teal: data.osm_street_id == entry.osm_type + \'/\' + entry.osm_id}\" class=\"circular icon checkmark\"></i><h2>{{entry.display_name}}</h2></div></material-item></material-list><div layout=\"horizontal\" layout-align=\"end\"><material-button ng-click=\"selectAddress(1)\">Query Again</material-button><material-button ng-click=\"selectingAddress = false\">close</material-button></div></material-content></material-whiteframe></material-card></material-content><div flex=\"flex\"><h4>By submitting, you agree the data will be released under CC0 or ODbl when stored on OSM.</h4><leaflet defaults=\"defaults\" center=\"center\" height=\"320px\" width=\"100%\" layout-fill=\"layout-fill\"></leaflet></div></div></div></material-content></section>");
$templateCache.put("app/partials/motions.html","<div ng-class=\"{list: sitting}\" class=\"motions\"><h1><a href=\"/motions/{{session}}\"></a>第八屆第二會期</h1><div ng-hide=\"sitting\" class=\"row-fluid\"><div class=\"span10 chart\"></div><div class=\"span2 legends\"></div></div><button id=\"btnTop\" ng-controller=\"topBtnCtrl\" ng-show=\"showBtn\" ng-click=\"jumpToTop()\" class=\"btn\">Jump to Top</button><div ng-show=\"sitting\" class=\"list\"><h2>第 {{sitting}} 次院會</h2><div class=\"row-fluid\"><div class=\"span2 sidebar\"><ul class=\"nav nav-list\"><li ng-repeat=\"s in allStatus\" ng-click=\"setStatus(s.key)\" ng-class=\"{active: s.key == status}\"><a href=\"#\">{{s.value}}</a></li></ul><input ng-model=\"filter\" placeholder=\"Search\" class=\"filter search-query\"/></div><div class=\"span10 content\"><ul class=\"nav nav-tabs\"><li ng-repeat=\"s in allTypes\" ng-click=\"setType(s.key)\" ng-class=\"{active: s.key == type}\"><a href=\"#\">{{s.value}}</a></li></ul><ul ng-class=\"{{type}}\" class=\"motions\"><li ng-repeat=\"e in entries | filter:{status: status} | filter:filter\" class=\"row\"><div class=\"avatars\"><span ng-repeat=\"avatar in e.avatars\"><img ng-src=\"http://avatars.io/52ed1f85c747b48148000053/{{avatar.avatar}}?size=small\" ng-alt=\"{{avatar.name}}\" ng-class=\"avatar.party\" class=\"avatar\"/></span></div><div class=\"motion\"><span class=\"item\">{{ e.item }}</span><span class=\"proposer\">{{ e.proposer }}</span><a ng-href=\"/bills/{{ e.id }}\"><span class=\"summary\">{{ e.summary }}</span></a></div><div class=\"resolution\">{{ e.resolution }}</div></li></ul></div></div></div></div>");
$templateCache.put("app/partials/nav.html","<material-toolbar scroll-shrink=\"scroll-shrink\" class=\"material-theme-light\"><div layout=\"horizontal\" class=\"material-toolbar-tools\"><h2><a href=\"/\" class=\"left floated item header brand\">投開票所鄉民 Geocode</a></h2><h3 layout-align=\"end\"><a ng-href=\"/about\" ng-class=\"{active:activeTab == \'about\'}\" class=\"item about\">關於</a></h3><a href=\"http://github.com/clkao/comap\" class=\"ui top right attached label build-id\">{{ config_build }}</a></div></material-toolbar>");}]);