import QtQuick 2.0

Item {
    id: control

    property real defualtItemWidth: 40
    property color color: Qt.hsla(0, 0, 0.95)
    property bool hide: false

    //readonly property alias listModel: listModel

    width: 200
    height: 80

    required property var listModel;

    Component {
        id: delegate
        NeumorphismCircleButton {
            width: defualtItemWidth
            color: control.color
            hide: control.hide
            enabled: control.enabled && activate
            onClicked: func(this);
            text.text: icon
        }
    }

    PathView {
        anchors.fill: parent
        model: control.listModel
        delegate: delegate
        pathItemCount: 5

        path: Path {
            startX: 0; startY: control.height*1.2

            PathCubic {
                x: control.width; y: control.height*1.2
                control1X: 50; control1Y: 0
                control2X: control.width-50; control2Y: 0
            }
        }
    }
}
