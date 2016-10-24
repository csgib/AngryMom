import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    width: parent.width
    height: parent.height / 6
    x:  0
    anchors.centerIn: parent
    z: 9
    opacity: 0

    Text{
        id: text_hit
        anchors.fill: parent
        font.bold: true
        text: ""
        color: "#FFFFFF"
        font.pixelSize: parent.height - 20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Glow {
        anchors.fill: text_hit
        radius: 3
        samples: 10
        color: "#000000"
        source: text_hit
        visible: true
    }

    DropShadow {
        anchors.fill: text_hit
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: text_hit
    }

    SequentialAnimation on opacity{
        id: show
        running: false
        loops: 1
        NumberAnimation {
            from: 0
            to: 1
            duration: 200
            easing.type: Easing.Linear
        }
    }

    SequentialAnimation on opacity{
        id: hide
        running: false
        loops: 1
        NumberAnimation {
            from: 1
            to: 0
            duration: 300
            easing.type: Easing.InOutBack
        }
    }

    function fn_show_hit(score)
    {
        if ( opacity == 0 )
        {
            text_hit.text = score
            show.start()
            timer_hide.start()
        }
        else
        {
            text_hit.text = (score+parseInt(text_hit.text))
            timer_hide.restart()
        }
    }

    function fn_hide_hit()
    {
        hide.start()
    }

    Timer {
        id: timer_hide
        interval: 1200
        running: false
        repeat: false
        onTriggered: fn_hide_hit()
    }
}
