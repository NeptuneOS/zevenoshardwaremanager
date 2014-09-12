import QtQuick 1.0
import org.kde.plasma.components 0.1 as PlasmaComponents  // Now use plasma Core QML Widgets

Rectangle {

    signal hpinstall;
    signal brotherinstall;
    signal graphicsdriverinstall(string version);
    signal pommedinstall;
    signal checkdriverinstalled();

    property bool graphicsAllowInstall: false
    
    function setBgColor(colorCode) {
	rectangle1.color = colorCode
    }
    
    function graphicsHighlight(text) {
        graphicstxt.font.pixelSize = 18
        graphicstxt.font.bold = true
    }

    function graphicsUnhighlight(text) {
        graphicstxt.font.pixelSize = 16
        graphicstxt.font.bold = false
    }

    function printerHighlight(text) {
        printertxt.font.pixelSize = 18
        printertxt.font.bold = true
    }

    function printerUnhighlight(text) {
        printertxt.font.pixelSize = 16
        printertxt.font.bold = false
    }

    function showHPInstallButton() {
        hpinstalltxt.visible = true
        hplogo.opacity = 0.5
    }

    function hideHPInstallButton() {
        hpinstalltxt.visible = false
        hplogo.opacity = 1
    }
    function showBrotherInstallButton() {
        brotherinstalltxt.visible = true
        brotherlogo.opacity = 0.5
    }

    function hideBrotherInstallButton() {
        brotherinstalltxt.visible = false
        brotherlogo.opacity = 1
    }

    function updateGraphicscardlbl(text) {
        graphicscardlbl.text = text
    }

    function updateGraphicsdriverimg(sourceimg) {
        graphicdriverimg.source = sourceimg
        if (sourceimg != "img/hardware.png") {
            graphicsinstalltxt.visible = true
            graphicsAllowInstall = true
        }
    }

    function showGraphicdriverInstallButton() {
        graphicsinstalltxt.visible = true
        graphicsAllowInstall = true
        //graphicdriverimg.opacity = 0.5
    }

    function showGraphicdriverInstalledButton() {
        graphicsinstalledtxt.visible = true
        //graphicdriverimg.opacity = 0.5
        graphicsinstalltxt.visible = false
        graphicsAllowInstall = false
    }

    function hideGraphicdriverInstallButton() {
        graphicsinstalltxt.visible = false
        graphicdriverimg.opacity = 1
    }
    function macbook_detected() {
        rectangle1.state = "Macbook"
    }

    function stable_driver(version) {
        stable_gdriver.text = version + " (stable)"
    }

    function experimental_driver(version) {
        experimental_gdriver.text = version + " (experimental)"
    }

    function hide_experimental_driver() {
        experimental_gdriver.visible = false
    }

    function showAbout() {
        aboutPage.opacity = 1
    }

    id: rectangle1
    width: 500
    height: 300
    color: "#C4BDBB"

    Text {
        id: title
        x: 187
        y: 53
        text: "Hardware Manager"
        anchors.horizontalCenterOffset: 48
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.bold: true
        font.pixelSize: 24
    }

    PlasmaComponents.Button {
        id: helpButton
        width:40
        height:24
        x:15
        y: rectangle1.height - 32 - 15
        //onClicked: rectangle1.showAbout()
        onClicked: helpMenu.open()

        Image {
            anchors.centerIn: parent
            width: parent.width - 2
            //height: parent.height - 1
            source: "img/configure.png"
            smooth: true
        }
    }

    PlasmaComponents.ContextMenu {
        id: helpMenu
        visualParent: helpButton
        PlasmaComponents.MenuItem {
            text: qsTr("About")
            icon: QIcon("gtk-about")
            onClicked: showAbout()
        }
    }

    Rectangle {
        id: aboutPage
        width: rectangle1.width -(rectangle1.width/8)
        height: rectangle1.height - (rectangle1.height/3)
        anchors.centerIn: rectangle1
        color: rectangle1.color
        border.color: "blue"
        border.width: 1
        radius: 8
        z:100  // Above all
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }

        PlasmaComponents.Button {
            anchors.right: parent.right
            anchors.top: parent.top
            text: "X"
            onClicked: parent.opacity = 0
        }

        Image {
            id: aboutLogo
            source: "img/about.png"
            x: 25
            y: 40
        }
        Text {
            id: aboutTxt
            text: qsTr("<b>ZevenOS Hardware Manager 2.3</b><br />released under the terms of <b>GPLv3</b><br /> by Leszek Lesner \
<br /><br />This application allows you<br>to install proprietary drivers<br />for your graphicscard or printer.")
            anchors.left: aboutLogo.right
            anchors.leftMargin: 20
            anchors.top: aboutLogo.top
        }
        MouseArea {
            anchors.fill: aboutPage
            onClicked: {
                aboutPage.opacity = 0
            }
        }
    }

    Image {
        id: image1
        x: 44
        y: 17
        width: 100
        height: 100
        anchors.horizontalCenterOffset: -156
        anchors.horizontalCenter: parent.horizontalCenter
        source: "img/hardware.png"

        MouseArea {
            id: mouse_area3
            x: 0
            y: 0
            width: 100
            height: 100
            onClicked: rectangle1.state = ""
        }
    }

    Image {
        id: image2
        x: 118
        y: 158
        width: 64
        height: 64
        anchors.verticalCenterOffset: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -100
        anchors.horizontalCenter: parent.horizontalCenter
        source: "img/graphicscard.png"

        MouseArea {
            id: mouse_area1
            x: -14
            y: 0
            width: 92
            height: 101
            anchors.leftMargin: -14
            anchors.rightMargin: -14
            anchors.bottomMargin: -37
            anchors.fill: parent
            hoverEnabled: true
            onEntered: graphicsHighlight()
            onExited: graphicsUnhighlight()
            onClicked: {
                rectangle1.state = "GraphicsClicked"
                checkdriverinstalled()
            }
        }
    }

    Image {
        id: image3
        x: 318
        y: 159
        width: 64
        height: 64
        anchors.verticalCenterOffset: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: 100
        anchors.horizontalCenter: parent.horizontalCenter
        source: "img/printer.png"

        MouseArea {
            id: mouse_area2
            width: 64
            height: 101
            anchors.bottomMargin: -37
            anchors.fill: parent
            hoverEnabled: true
            onEntered: printerHighlight()
            onExited: printerUnhighlight()
            onClicked: rectangle1.state = "PrinterClicked"
        }
    }

    Text {
        id: hplbl
        x: 108
        y: 0
        text: "text"
        font.pixelSize: 12
        opacity: 0
    }

    Text {
        id: graphicstxt
        x: 104
        y: 231
        text: "Graphicscard"
        font.bold: false
        anchors.verticalCenterOffset: 60
        anchors.verticalCenter: image2.verticalCenter
        anchors.horizontalCenter: image2.horizontalCenter
        font.pixelSize: 16
    }

    Text {
        id: printertxt
        x: 325
        y: 231
        text: "Printer"
        anchors.verticalCenterOffset: 60
        anchors.verticalCenter: image3.verticalCenter
        anchors.horizontalCenter: image3.horizontalCenter
        font.pixelSize: 16
    }

    Text {
        id: text1
        x: 150
        y: 91
        width: 315
        text: "Some hardware needs special drivers to run properly. You can install them from here."
        anchors.bottom: image1.top
        anchors.bottomMargin: -100
        anchors.horizontalCenterOffset: 10
        anchors.horizontalCenter: title.horizontalCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

    Text {
        id: graphicscarddetectedlbl
        x: 150
        y: 148
        text: "Graphicscard detected:"
        font.pixelSize: 12
        opacity: 0
    }

    Text {
        id: graphicscardlbl
        x: 293
        y: 148
        text: "Graphicscard here"
        font.pixelSize: 12
        opacity: 0
    }

    PlasmaComponents.ButtonColumn {
        id: gdriver_radio
        anchors.top: graphicscardlbl.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: text1.horizontalCenter
        visible: false
        PlasmaComponents.RadioButton {
            id: stable_gdriver
            text: "Stable driver"
        }
        PlasmaComponents.RadioButton {
            id: experimental_gdriver
            text: "Experimental driver"
        }
    }

    Text {
        id: brotherlbl
        x: 332
        y: 148
        text: "text"
        font.pixelSize: 12
        opacity: 0
    }

    Image {
        id: hplogo
        x: 157
        y: 175
        width: 100
        height: 100
        source: "img/hp-logo.png"
        opacity: 0
    }

    Image {
        id: brotherlogo
        x: 333
        y: 184
        width: 100
        height: 100
        source: "img/brother-logo.png"
        opacity: 0
    }

    PlasmaComponents.Button {
        id: hpinstalltxt
        anchors.horizontalCenter: hplogo.horizontalCenter
        anchors.top: hplogo.bottom
        anchors.topMargin: 5
        text: "Install"
        font.pixelSize: 12
        opacity: 0
        onClicked: hpinstall()
    }

    MouseArea {
        id: mouse_area4
        x: 175
        y: 184
        width: 100
        height: 100
        opacity: 0
    }

    MouseArea {
        id: mouse_area5
        x: 320
        y: 203
        width: 100
        height: 100
        opacity: 0
    }

    PlasmaComponents.Button {
        id: brotherinstalltxt
        anchors.horizontalCenter: brotherlogo.horizontalCenter
        anchors.verticalCenter: hpinstalltxt.verticalCenter
        text: "Install"
        font.pixelSize: 12
        opacity: 0
        onClicked: brotherinstall()
    }

    PlasmaComponents.Button {
        id: graphicsinstalltxt
        anchors.horizontalCenter: text1.horizontalCenter
        anchors.top: gdriver_radio.bottom
        anchors.topMargin: 10
        text: "Install"
        font.pixelSize: 12
        opacity: 0
        onClicked: {
            if (stable_gdriver.checked) {
                graphicsdriverinstall("stable")
            }
            else if (experimental_gdriver.checked) {
                graphicsdriverinstall("experimental")
            }
        }
    }

    Text {
        id: graphicsinstalledtxt
        anchors.horizontalCenter: text1.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 45
        text: "Driver installed"
        font.pixelSize: 12
        opacity: 0
    }

    Image {
        id: graphicdriverimg
        x: 248
        y: 184
        width: 100
        height: 100
        source: "img/clean.png"
        opacity: 0
        anchors.right: undefined
    }

    PlasmaComponents.Button {
        id: backimg
        x: 8
        y: 6
        width:100
        height:100
        iconSource: "go-previous"
        visible: false
        onClicked: rectangle1.state = ""
    }



    states: [
        State {
            name: "GraphicsClicked"

            PropertyChanges {
                target: mouse_area1
                x: -14
                y: 0
                hoverEnabled: false
                anchors.topMargin: 0
                anchors.rightMargin: -14
                anchors.bottomMargin: -37
                anchors.leftMargin: -14
            }

            PropertyChanges {
                target: image2
                x: 44
                y: 148
                anchors.horizontalCenterOffset: -174
                anchors.verticalCenterOffset: 30
            }

            PropertyChanges {
                target: mouse_area2
                x: 0
                y: 0
                visible: false
                anchors.topMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: -37
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: gdriver_radio
                visible: {
                    if (graphicsinstalltxt.visible) {
                        true
                    }
                    else {
                        false
                    }
                }
            }

            PropertyChanges {
                target: image3
                opacity: 0
            }

            PropertyChanges {
                target: printertxt
                opacity: 0
            }

            PropertyChanges {
                target: graphicscarddetectedlbl
                opacity: 1
            }

            PropertyChanges {
                target: graphicscardlbl
                width: 180
                wrapMode: "WordWrap"
                opacity: 1
            }

            PropertyChanges {
                target: graphicdriverimg
                anchors.right: rectangle1.right
                anchors.rightMargin: 15
                y: 210
                width: 64
                height: 64
                opacity: 1
                scale: 1
            }

            PropertyChanges {
                target: backimg
                x: 5
                y: 17
                width: 32
                height: 32
                smooth: true
                visible: true
                opacity: 1
            }

            PropertyChanges {
                target: mouse_area3
                x: 0
                y: 0
            }

//             PropertyChanges {
//                 target: backbtn
//                 x: 0
//                 y: 0
//                 width: 42
//                 height: 42
//                 opacity: 1
//                 onClicked: rectangle1.state = ""
//             }

            PropertyChanges {
                target: graphicsinstalltxt
                text: "Install"
                opacity: 1
                visible: graphicsAllowInstall
                //horizontalAlignment: Text.AlignLeft
                font.pixelSize: 16
                font.bold: true
            }

            PropertyChanges {
                target: graphicsinstalledtxt
                opacity: 1
                visible: !graphicsAllowInstall
                //horizontalAlignment: Text.AlignLeft
                font.pixelSize: 16
                font.bold: true
            }
        },
        State {
            name: "PrinterClicked"

            PropertyChanges {
                target: mouse_area1
                x: -14
                y: 0
                hoverEnabled: false
                anchors.topMargin: 0
                anchors.rightMargin: -14
                anchors.bottomMargin: -37
                anchors.leftMargin: -14
            }

            PropertyChanges {
                target: image3
                x: 44
                y: 148
                anchors.horizontalCenterOffset: -174
                anchors.verticalCenterOffset: 30
            }

            PropertyChanges {
                target: mouse_area2
                x: 0
                y: 0
                visible: false
                anchors.topMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: -37
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: image2
                opacity: 0
            }

            PropertyChanges {
                target: printertxt
                opacity: 1
            }

            PropertyChanges {
                target: graphicscarddetectedlbl
                opacity: 0
            }

            PropertyChanges {
                target: graphicstxt
                opacity: 0
            }

            PropertyChanges {
                target: hplbl
                x: 150
                y: 148
                text: "HPLip Printer Driver"
                font.bold: false
                opacity: 1
            }

            PropertyChanges {
                target: brotherlbl
                x: 320
                y: 148
                text: "Brother Printer Driver"
                opacity: 1
            }

            PropertyChanges {
                target: hplogo
                x: 175
                y: 184
                width: 64
                height: 65
                source: "img/hp-logo.png"
                opacity: 1
            }

            PropertyChanges {
                target: brotherlogo
                x: 319
                y: 203
                width: 128
                height: 28
                source: "img/brother-logo.png"
                opacity: 1
            }

            PropertyChanges {
                target: hpinstalltxt
                text: "Install"
                visible: true
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 16
                font.bold: true
                opacity: 1
                anchors.horizontalCenter: hplogo.horizontalCenter
            }

            PropertyChanges {
                target: mouse_area4
                width: 64
                height: 65
                opacity: 1
                hoverEnabled: true
                //onEntered: showHPInstallButton()
                //onExited: hideHPInstallButton()
                onClicked: hpinstall()
            }

            PropertyChanges {
                target: mouse_area5
                width: 127
                height: 28
                opacity: 1
                hoverEnabled: true
                //onEntered: showBrotherInstallButton()
                //onExited: hideBrotherInstallButton()
                onClicked: brotherinstall()
            }

            PropertyChanges {
                target: brotherinstalltxt
                text: "Install"
                visible: true
                font.bold: true
                font.pixelSize: 16
                opacity: 1
                anchors.horizontalCenter: brotherlogo.horizontalCenter
            }

            PropertyChanges {
                target: backimg
                x: 5
                y: 17
                width: 32
                height: 32
                visible: true
                smooth: true
                opacity: 1
            }

//             PropertyChanges {
//                 target: backbtn
//                 x: 0
//                 y: 0
//                 width: 42
//                 height: 42
//                 opacity: 1
//                 onClicked: rectangle1.state = ""
//             }
        }
    ]
    transitions: [

        // When transitioning to 'middleRight' move x,y over a duration of 1 second,
        // with OutBounce easing function.
        Transition {
            from: ""; to: "PrinterClicked"
            NumberAnimation { target: image3; properties: "x,y"; easing.type: Easing.OutQuad; duration: 1000 }
            NumberAnimation { target: image2; properties: "opacity"; easing.type: Easing.Linear; duration: 1000 }
        },
        Transition {
            from: "PrinterClicked"; to: ""
            NumberAnimation { target: image3; properties: "x,y"; easing.type: Easing.OutQuad; duration: 1000 }
            NumberAnimation { target: image2; properties: "opacity"; easing.type: Easing.Linear; duration: 1000 }
        },
        Transition {
            from: ""; to: "GraphicsClicked"
            NumberAnimation { target: image2; properties: "x,y"; easing.type: Easing.OutQuad; duration: 1000 }
            NumberAnimation { target: image3; properties: "opacity"; easing.type: Easing.Linear; duration: 1000 }
        },

        // When transitioning to 'bottomLeft' move x,y over a duration of 2 seconds,
        // with InOutQuad easing function.
        Transition {
            from: "GraphicsClicked"; to: ""
            NumberAnimation { target: image2; properties: "x,y"; easing.type: Easing.OutQuad; duration: 1000 }
            NumberAnimation { target: image3; properties: "opacity"; easing.type: Easing.Linear; duration: 1000 }
        },

        // For any other state changes move x,y linearly over duration of 200ms.
        Transition {
            NumberAnimation { properties: "x,y"; duration: 200 }
        }
    ]

}
