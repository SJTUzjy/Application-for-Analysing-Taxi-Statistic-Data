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
            pointModel.insert(idx, {"departure_latitude":orig_lat, "departure_longitude":orig_lng})
            map.center = QtPositioning.coordinate(30.67, 104.07)
        }
        function drawRegion(idx1, idx2, clr){
            regionModel.append({"topLeft_lat":topleft_lat[idx1], "topLeft_lng":topleft_lng[idx2], "bottomRight_lat":bottomright_lat[idx1], "bottomRight_lng":bottomright_lng[idx2], "region_color":clr})
            map.center = QtPositioning.coordinate(30.67, 104.07)
        }
        function removeRegion(idx) {
            regionModel.remove(idx)
        }
        ListModel{
            id:regionModel
            ListElement{
                topLeft_lat:30
                topLeft_lng:104
                bottomRight_lat:29
                bottomRight_lng:105
                region_color:"#ffffff"
            }
        }
        Component{
            id:regionDelegate
            MapRectangle{
                border.width:5
                border.color:'white'
                color:region_color
                opacity:0.2
                topLeft{
                    latitude:topLeft_lat
                    longitude:topLeft_lng
                }
                bottomRight{
                    latitude:bottomRight_lat
                    longitude:bottomRight_lng
                }
            }
        }
        MapItemView{
            model:regionModel
            delegate: regionDelegate
            autoFitViewport: false
        }

        Connections{
            target: viceWindow
            onShowRegion:{
                map.drawRegion(idx1, idx2, clr)
            }
            onRemoveRegion:{
                map.removeRegion(idx)
            }
            onClearRegion:{
                regionModel.clear()
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_0
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"1"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_1
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"2"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_2
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"3"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_3
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"4"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_4
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"5"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_5
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"6"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_6
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"7"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_7
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"8"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_8
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"9"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[0]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[0]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_9
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[0],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"10"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_10
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"11"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_11
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"12"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_12
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"13"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_13
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"14"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_14
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"15"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_15
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"16"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_16
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"17"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_17
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"18"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_18
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"19"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[1]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[1]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_19
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[1],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"20"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_20
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"21"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_21
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"22"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_22
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"23"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_23
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"24"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_24
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"25"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_25
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"26"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_26
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"27"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_27
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"28"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_28
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"29"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[2]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[2]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_29
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[2],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"30"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_30
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"31"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_31
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"32"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_32
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"33"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_33
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"34"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_34
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"35"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_35
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"36"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_36
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"37"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_37
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"38"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_38
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"39"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[3]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[3]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_39
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[3],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"40"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_40
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"41"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_41
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"42"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_42
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"43"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_43
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"44"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_44
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"45"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_45
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"46"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_46
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"47"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_47
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"48"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_48
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"49"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[4]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[4]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_49
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[4],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"50"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_50
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"51"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_51
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"52"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_52
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"53"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_53
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"54"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_54
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"55"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[5]
                 }
             }
        MapQuickItem{
            id:point_55
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"56"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[6]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[6]
                 }
             }
        MapQuickItem{
            id:point_56
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[6])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"57"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[7]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[7]
                 }
             }
        MapQuickItem{
            id:point_57
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[7])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"58"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[8]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[8]
                 }
             }
        MapQuickItem{
            id:point_58
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[8])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"59"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[5]
                     longitude: topleft_lng[9]
                 }
                 bottomRight {
                     latitude: bottomright_lat[5]
                     longitude: bottomright_lng[9]
                 }
             }
        MapQuickItem{
            id:point_59
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[5],center_lng[9])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"60"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[0]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[0]
                 }
             }
        MapQuickItem{
            id:point_60
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[0])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"61"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[1]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[1]
                 }
             }
        MapQuickItem{
            id:point_61
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[1])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"62"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[2]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[2]
                 }
             }
        MapQuickItem{
            id:point_62
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[2])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"63"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[3]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[3]
                 }
             }
        MapQuickItem{
            id:point_63
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[3])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"64"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[4]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[4]
                 }
             }
        MapQuickItem{
            id:point_64
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[4])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"65"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
        MapRectangle {
                 border.width: 5
                 border.color: 'white'
                 topLeft {
                     latitude: topleft_lat[6]
                     longitude: topleft_lng[5]
                 }
                 bottomRight {
                     latitude: bottomright_lat[6]
                     longitude: bottomright_lng[5]
                 }
        }
        MapQuickItem{
            id:point_65
            zoomLevel: 10
            coordinate: QtPositioning.coordinate(center_lat[6],center_lng[5])
            sourceItem: Rectangle{
                Text{
                    anchors.centerIn:parent
                    text:"66"
                    color:"black"
                    opacity:0.35
                    font.bold:true
                    font.pixelSize: 30
                }
            }
        }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[6]
                              longitude: topleft_lng[6]
                          }
                          bottomRight {
                              latitude: bottomright_lat[6]
                              longitude: bottomright_lng[6]
                          }
                      }
                 MapQuickItem{
                     id:point_66
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[6],center_lng[6])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"67"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[6]
                              longitude: topleft_lng[7]
                          }
                          bottomRight {
                              latitude: bottomright_lat[6]
                              longitude: bottomright_lng[7]
                          }
                      }
                 MapQuickItem{
                     id:point_67
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[6],center_lng[7])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"68"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[6]
                              longitude: topleft_lng[8]
                          }
                          bottomRight {
                              latitude: bottomright_lat[6]
                              longitude: bottomright_lng[8]
                          }
                      }
                 MapQuickItem{
                     id:point_68
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[6],center_lng[8])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"69"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[6]
                              longitude: topleft_lng[9]
                          }
                          bottomRight {
                              latitude: bottomright_lat[6]
                              longitude: bottomright_lng[9]
                          }
                      }
                 MapQuickItem{
                     id:point_69
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[6],center_lng[9])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"70"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[0]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[0]
                          }
                      }
                 MapQuickItem{
                     id:point_70
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[0])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"71"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[1]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[1]
                          }
                      }
                 MapQuickItem{
                     id:point_71
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[1])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"72"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[2]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[2]
                          }
                      }
                 MapQuickItem{
                     id:point_72
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[2])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"73"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[3]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[3]
                          }
                      }
                 MapQuickItem{
                     id:point_73
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[3])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"74"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[4]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[4]
                          }
                      }
                 MapQuickItem{
                     id:point_74
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[4])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"75"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[5]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[5]
                          }
                      }
                 MapQuickItem{
                     id:point_75
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[5])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"76"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[6]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[6]
                          }
                      }
                 MapQuickItem{
                     id:point_76
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[6])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"77"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[7]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[7]
                          }
                      }
                 MapQuickItem{
                     id:point_77
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[7])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"78"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[8]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[8]
                          }
                      }
                 MapQuickItem{
                     id:point_78
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[8])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"79"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[7]
                              longitude: topleft_lng[9]
                          }
                          bottomRight {
                              latitude: bottomright_lat[7]
                              longitude: bottomright_lng[9]
                          }
                      }
                 MapQuickItem{
                     id:point_79
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[7],center_lng[9])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"80"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[0]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[0]
                          }
                      }
                 MapQuickItem{
                     id:point_80
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[0])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"81"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[1]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[1]
                          }
                      }
                 MapQuickItem{
                     id:point_81
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[1])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"82"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[2]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[2]
                          }
                      }
                 MapQuickItem{
                     id:point_82
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[2])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"83"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[3]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[3]
                          }
                      }
                 MapQuickItem{
                     id:point_83
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[3])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"84"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[4]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[4]
                          }
                      }
                 MapQuickItem{
                     id:point_84
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[4])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"85"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[5]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[5]
                          }
                      }
                 MapQuickItem{
                     id:point_85
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[5])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"86"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[6]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[6]
                          }
                      }
                 MapQuickItem{
                     id:point_86
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[6])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"87"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[7]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[7]
                          }
                      }
                 MapQuickItem{
                     id:point_87
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[7])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"88"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[8]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[8]
                          }
                      }
                 MapQuickItem{
                     id:point_88
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[8])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"89"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[8]
                              longitude: topleft_lng[9]
                          }
                          bottomRight {
                              latitude: bottomright_lat[8]
                              longitude: bottomright_lng[9]
                          }
                      }
                 MapQuickItem{
                     id:point_89
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[8],center_lng[9])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"90"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[0]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[0]
                          }
                      }
                 MapQuickItem{
                     id:point_90
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[0])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"91"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[1]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[1]
                          }
                      }
                 MapQuickItem{
                     id:point_91
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[1])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"92"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[2]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[2]
                          }
                      }
                 MapQuickItem{
                     id:point_92
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[2])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"93"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[3]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[3]
                          }
                      }
                 MapQuickItem{
                     id:point_93
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[3])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"94"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[4]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[4]
                          }
                      }
                 MapQuickItem{
                     id:point_94
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[4])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"95"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[5]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[5]
                          }
                      }
                 MapQuickItem{
                     id:point_95
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[5])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"96"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[6]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[6]
                          }
                      }
                 MapQuickItem{
                     id:point_96
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[6])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"97"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[7]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[7]
                          }
                      }
                 MapQuickItem{
                     id:point_97
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[7])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"98"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[8]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[8]
                          }
                      }
                 MapQuickItem{
                     id:point_98
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[8])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"99"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
                 MapRectangle {
                          border.width: 5
                          border.color: 'white'
                          topLeft {
                              latitude: topleft_lat[9]
                              longitude: topleft_lng[9]
                          }
                          bottomRight {
                              latitude: bottomright_lat[9]
                              longitude: bottomright_lng[9]
                          }
                      }
                 MapQuickItem{
                     id:point_99
                     zoomLevel: 10
                     coordinate: QtPositioning.coordinate(center_lat[9],center_lng[9])
                     sourceItem: Rectangle{
                         Text{
                             anchors.centerIn:parent
                             text:"100"
                             color:"black"
                             opacity:0.35
                             font.bold:true
                             font.pixelSize: 30
                         }
                     }
                 }
    }
}
