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
        z: 0
    }

    Text {
        color: "#FFFFFF"
        font.pixelSize: 20
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Vous avez perdu")
        y: 290
        z: 1
    }

    Text {
        z: 1
        y: parent.height - 100
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Recommencer ...")
        color: "#FFFFFF"
        font.pixelSize: 30
        MouseArea{
            anchors.fill: parent
            onClicked: {
                game_area.fn_emptyField()
                if ( wg_game_syno[wg_current_level][0] == "N" )
                {
                    game_area.fn_initializeField_random()
                }
                else
                {
                    game_area.fn_initializeField(wg_game_syno[wg_current_level][0])
                }
                game_area.time_remaining = wg_game_syno[wg_current_level][3]
                game_area.game_score = 0
                game_area.visible = true
                game_failed.visible = false
            }
        }
    }
}
