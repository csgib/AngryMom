/* ============================================================
 * Project  : AngryMom
 * Author   : Stephane Gibault
 * Date     : Wed Aug 22 2016
 * Description :
 *
 *
 *  (C) 2007 by Stephane Gibault
 *
 * This program is free software; you can redistribute it
 * and/or modify it under the terms of the GNU General
 * Public License as published by the Free Software Foundation;
 * either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * ============================================================ */

import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#AA000000"
    }

    Label {
        id: order_text
        width: parent.width - 60
        height: (parent.height-160) / 4
        y: 100
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        color: "#f8b1c1"
        font.pixelSize: height / 4
        font.bold: false
        text: ""
        wrapMode: Text.WordWrap
    }

    Text{
        id: start_button
        text: qsTr("Allons y ...")
        color: "#FFFFFF"
        font.pixelSize: 50
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        y: parent.height-110
        MouseArea{
            anchors.fill: parent
            onClicked: {
                game_order.visible = false
                game_area.fn_next_level()
            }
        }
    }

    function fn_display_order(wl_current_level)
    {
        order_text.text = wg_game_syno[wl_current_level][1]
        order_text.text += "\n\n" + qsTr("Objectif : ") + wg_game_syno[wl_current_level][2] + qsTr(" points en ") + wg_game_syno[wl_current_level][3]/60 + qsTr(" minutes")
        game_order.visible = true
    }
}
