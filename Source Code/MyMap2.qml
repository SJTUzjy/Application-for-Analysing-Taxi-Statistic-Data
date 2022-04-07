import QtQuick 2.5
import QtQuick.Window 2.14
import QtLocation 5.9
import QtPositioning 5.6
import QtQuick.Controls 1.4
import QtQuick.Shapes 1.1

Rectangle {
    width: 512//Qt.platform.os == "android" ? Screen.width : 512
    height:512 //Qt.platform.os == "android" ? Screen.height : 512
    visible: true
    signal is_clicked(lat: var, lng: var)
    property var topleft_lat:[30.4791159329014,
                                30.524081949676,
                                30.5690479664507,
                                30.6140139832253,
                                30.65898,
                                30.7039460167746,
                                30.7489120335492,
                                30.7938780503239,
                                30.8388440670985,
                                30.8838100838732]
    property var topleft_lng:[103.803861790885, 103.856134632708, 103.908407474531, 103.960680316354, 104.012953158177, 104.065226, 104.117498841822, 104.169771683645, 104.222044525468, 104.274317367291]
    property var bottomright_lat:[30.43414992, 30.47911593, 30.52408195, 30.56904797, 30.61401398, 30.65898, 30.70394602, 30.74891203, 30.79387805, 30.83884407]
    property var bottomright_lng: [103.8561346, 103.9084075, 103.9606803, 104.0129532, 104.065226, 104.1174988, 104.1697717, 104.2220445, 104.2743174, 104.3265902]
    property var center_lat:[30.45663292, 30.50159894, 30.54656496, 30.59153097, 30.63649699, 30.68146301, 30.72642903, 30.77139504, 30.81636106, 30.86132708]
    property var center_lng:[103.8299982, 103.8822711, 103.9345439, 103.9868167, 104.0390896, 104.0913624, 104.1436353, 104.1959081, 104.2481809, 104.3004538]
    Plugin {
        id: mapPlugin
        name: "osm"
    }


    Map {
        id:map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(30.67, 104.07)
        zoomLevel: 10


        Location {
            id: marker
            coordinate {
                latitude:0
                longitude:0
            }

        }

        MouseArea {
            id:mous
            anchors.fill: parent

            onClicked: {
                marker.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                is_clicked(marker.coordinate.latitude, marker.coordinate.longitude)
            }
        }

        RouteModel {
            id: routeModel
            plugin : map.plugin
            query: RouteQuery{
                id:routeQuery
            }
        }
        function drawRoute(orig_lat, orig_lng, dest_lat, dest_lng){
            var startCoordinate = QtPositioning.coordinate(orig_lat, orig_lng)
            var endCoordinate = QtPositioning.coordinate(dest_lat, dest_lng)
            routeQuery.clearWaypoints()
            routeQuery.addWaypoint(startCoordinate)
            routeQuery.addWaypoint(endCoordinate)
            routeQuery.travelModes = RouteQuery.PedestrianTravel
            routeQuery.routeOptimizations = RouteQuery.FastestRoute
            for(var i = 0; i < 9; i++) {
                routeQuery.setFeatureWeight(i, 0)
            }
            routeModel.update();
            map.center = startCoordinate;
        }
        function drawPoint(idx, orig_lat, orig_lng){
            if(idx == 0) {
                pointModel1.clear()
                pointModel1.append({"departure_latitude":orig_lat, "departure_longitude":orig_lng})
            }
            else {
                pointModel2.clear()
                pointModel2.append({"departure_latitude":orig_lat, "departure_longitude":orig_lng})
            }
        }
        function removePoint(idx) {
            pointModel.remove(idx)
        }

        MapItemView {
            model: routeModel
            delegate: routeDelegate
            autoFitViewport: true
        }
        Component {
            id: routeDelegate
            MapRoute {
                route: routeData
                line.color: "blue"
                line.width: 5
                smooth: true
                opacity: 0.8
            }
        }
        ListModel {
            id: pointModel1
        }
        Component{
            id:pointDelegate1
            MapQuickItem{
                coordinate: QtPositioning.coordinate(departure_latitude,departure_longitude)
                sourceItem: Image {
                    id: testImage
                    source: "qrc:/resources/marker.png"
                    opacity: 0.7
                }
            }
        }
        MapItemView{
            model:pointModel1
            delegate: pointDelegate1
            autoFitViewport: false
        }
        ListModel {
                id: pointModel2
        }
        Component{
            id:pointDelegate2
            MapQuickItem{
                coordinate: QtPositioning.coordinate(departure_latitude,departure_longitude)
                sourceItem: Image {
                    id: testImage
                    source: "qrc:/resources/marker1.png"
                    opacity: 0.7
                }
            }
        }
        MapItemView{
            model:pointModel2
            delegate: pointDelegate2
            autoFitViewport: false
        }
        Connections{
            target: viceWindow
            onShowRoute:{
                map.drawRoute(orig_lat, orig_lng, dest_lat, dest_lng)
            }
            onShowPoint:{
                map.drawPoint(idx, orig_lat, orig_lng)
            }
        }
    }
}
