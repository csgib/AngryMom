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
import QtGraphicalEffects 1.0
import "Data_store.js" as Storage

Item {
    width: parent.width
    height: parent.height
    anchors.fill: parent
    visible: true

    Image{
        id: title_start_page
        y: 40
        width: parent.width
        source: "Images/title.png"
        fillMode: Image.PreserveAspectFit
        z: 1
    }

    Text{
        id: start_button
        text: qsTr("Démarrer")
        color: "#FFFFFF"
        font.pixelSize: parent.width/8
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        y: 50+title_start_page.height
        MouseArea{
            anchors.fill: parent
            onClicked: {
                wg_current_level = 0
                Storage.set("BDATE", Qt.formatDateTime(new Date(), "yyyyMMddHHmmss"))

                fn_start_game()
            }
        }
    }

    Text{
        id: continue_button
        text: qsTr("Continuer")
        color: "#FFFFFF"
        font.pixelSize: parent.width/8
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        y: start_button.y+start_button.height+20
        MouseArea{
            anchors.fill: parent
            onClicked: {
                wg_current_level = game_area.fn_get_actual_level()
                fn_start_game()
            }
        }
        visible: false
    }

    Glow {
        anchors.fill: start_button
        radius: 3
        samples: 20
        color: "black"
        source: start_button
        visible: true
    }

    Glow {
        id: continue_button_glow
        anchors.fill: continue_button
        radius: 3
        samples: 20
        color: "black"
        source: continue_button
        visible: false
    }

    Component.onCompleted: {
        if ( game_area.fn_get_actual_level() > 0 )
        {
            continue_button.visible = true
            continue_button_glow.visible = true
        }
    }

    function fn_display_continue()
    {
        continue_button.visible = true
        continue_button_glow.visible = true
    }
}
