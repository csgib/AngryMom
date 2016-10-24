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

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtMultimedia 5.5

ApplicationWindow {
    visible: true
    width: 480 //Screen.width
    height: 800 //Screen.height
    minimumHeight: height
    minimumWidth: width
    maximumHeight: height
    maximumWidth: width
    title: "Angry Mom"
    id: myarea
    property int wg_current_level: 0

    property var wg_game_syno: [["N", qsTr("Maman est grognon parce que l'on mange trop de gras... (sacrée maman ;-) ) Aidons la à supprimer tout ce gras."), 15000,300,0],
                               ["N", qsTr("Bravo mais il en reste encore... On va arranger ça dans les prochains niveaux."), 18000,300,0],
                               ["0", qsTr("Papa veut empêcher maman de supprimer tout le gras. Pour cela il a placé des obstacles que vous devrez contourner pour aider maman."), 20000,300,0],
                               ["1", qsTr("Papa ben il est tordu, sur les 3 prochains niveaux il va falloir en faire disparaitre encore plus."), 22000,300,0],
                               ["N", "", 24000,300,0],
                               ["1", "", 26000,300,0],
                               ["3", qsTr("Un petit jeu pour maman, faites exploser les 3 coeurs pour réussir ce niveau"), 99999,300,0],
                               ["4", qsTr("Sauf que papa n'achète plus de gras maintenant... Et comme le gras c'est la vie tout le monde est malade. Enlevons un peu de toute cette nourriture de lapin."), 28000,300,1],
                               ["2", qsTr("Papa ben il est tordu, sur les 3 prochains niveaux il va falloir en faire disparaitre encore plus."), 35000,540,1],
                               ["1", "", 40000,540,1],
                               ["N", "", 45000,540,1],
                               ["0", "", 50000,540,1],
                               ["4", qsTr("Maintenant c'est bébé qui fait des siennes et qui laisse ses jouets partout. Rangeons un peu."), 51000,540,2],
                               ["5", qsTr("Un petit jeu pour maman, faites exploser les 3 coeurs pour réussir ce niveau"), 99999,300,2]
                               ]

    property var field_level: []

    // *******************************************
    // *** BACKGROUND OF GAME / ALWAYS DISPLAY ***
    // *******************************************
    Rectangle{
        anchors.fill: parent
        color: "#FFf69fb6"
    }

    Image{
        id: background_rotate
        source: "Images/fond_rotate.png"
        z: 0

        RotationAnimator {
            id: background_rotate_animator
            target: background_rotate;
            from: 0;
            to: 360;
            duration: 10000
            running: true
            loops: 9999
        }
    }

    Image {
        id: mombackground
        source: "Images/start_image.png"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        z: 1
    }

    // ***********************
    // *** SCREENS OF GAME ***
    // ***********************
    Game_start{
        anchors.fill: parent
        id: game_start
        z: 2
        visible: true
    }

    Game_area{
        anchors.fill: parent
        id: game_area
        z: 3
        visible: false
    }

    Game_order{
        anchors.fill: parent
        id: game_order
        z: 4
        visible: false
    }

    Game_success{
        anchors.fill: parent
        id: game_success
        z: 4
        visible: false
    }

    Game_failed{
        anchors.fill: parent
        id: game_failed
        z: 4
        visible: false
    }

    Game_win{
        anchors.fill: parent
        id: game_win
        z: 4
        visible: false
    }

    // ***************************
    // *** AUDIO GAME ELEMENTS ***
    // ***************************
    Audio {
        id: game_track
        autoPlay: false
        loops: Audio.Infinite
        autoLoad: true
        source: "Sounds/game_track.mp3"
        volume: 0.7
    }

    SoundEffect {
        id: plop
        source: "Sounds/plop.wav"
        volume: 1.0
    }

    SoundEffect {
        id: applause
        source: "Sounds/applause.wav"
        volume: 1.0
    }

    SoundEffect {
        id: rire
        source: "Sounds/rire.wav"
        volume: 1.0
    }

    SoundEffect {
        id: rock_explode
        source: "Sounds/rock_explode.wav"
        volume: 1.0
    }

    // ****************************************
    // *** FUNCTIONS START OR CONTINUE GAME ***
    // ****************************************

    function fn_start_game()
    {
        game_track.play()

        field_level[0] = "Y;Y;Y;Y;Y;Y"
        field_level[1] = "Y;Y;Y;Y;Y;Y"
        field_level[2] = "Y;Y;Y;Y;Y;Y"
        field_level[3] = "Y;9;Y;Y;9;Y"
        field_level[4] = "Y;Y;Y;Y;Y;Y"
        field_level[5] = "Y;Y;9;Y;Y;9"
        field_level[6] = "Y;Y;Y;Y;Y;Y"
        field_level[7] = "Y;Y;Y;Y;Y;Y"
        // ---------------------------
        field_level[8] = "Y;Y;Y;Y;Y;Y"
        field_level[9] = "Y;Y;Y;Y;Y;Y"
        field_level[10] = "Y;Y;Y;Y;Y;Y"
        field_level[11] = "Y;Y;Y;Y;Y;Y"
        field_level[12] = "Y;Y;Y;Y;Y;Y"
        field_level[13] = "9;Y;9;Y;9;Y"
        field_level[14] = "Y;Y;Y;Y;Y;Y"
        field_level[15] = "Y;Y;Y;Y;Y;Y"
        // ---------------------------
        field_level[16] = "Y;Y;Y;Y;Y;Y"
        field_level[17] = "Y;Y;Y;Y;Y;Y"
        field_level[18] = "Y;Y;Y;Y;Y;Y"
        field_level[19] = "Y;9;Y;9;Y;Y"
        field_level[20] = "Y;Y;Y;Y;Y;Y"
        field_level[21] = "9;Y;Y;Y;9;Y"
        field_level[22] = "Y;Y;Y;Y;Y;Y"
        field_level[23] = "Y;Y;Y;Y;Y;Y"
        // ---------------------------
        field_level[24] = "Y;Y;4;Y;Y;Y"
        field_level[25] = "Y;Y;Y;Y;Y;Y"
        field_level[26] = "Y;Y;Y;Y;Y;Y"
        field_level[27] = "Y;Y;Y;Y;Y;Y"
        field_level[28] = "Y;Y;Y;Y;Y;Y"
        field_level[29] = "Y;Y;Y;Y;Y;Y"
        field_level[30] = "Y;Y;Y;Y;Y;Y"
        field_level[31] = "Y;Y;4;4;Y;Y"
        // ---------------------------
        field_level[32] = "Y;Y;Y;Y;Y;Y"
        field_level[33] = "Y;Y;Y;Y;Y;Y"
        field_level[34] = "Y;Y;Y;Y;Y;Y"
        field_level[35] = "Y;9;Y;Y;9;Y"
        field_level[36] = "Y;Y;Y;Y;Y;Y"
        field_level[37] = "Y;9;Y;Y;9;Y"
        field_level[38] = "Y;Y;Y;Y;Y;Y"
        field_level[39] = "Y;Y;Y;Y;Y;Y"
        // ---------------------------
        field_level[40] = "Y;Y;Y;4;Y;Y"
        field_level[41] = "Y;Y;Y;Y;Y;Y"
        field_level[42] = "Y;Y;Y;Y;Y;Y"
        field_level[43] = "Y;9;Y;Y;9;Y"
        field_level[44] = "Y;Y;Y;Y;Y;Y"
        field_level[45] = "Y;9;Y;Y;9;Y"
        field_level[46] = "Y;Y;Y;Y;Y;Y"
        field_level[47] = "Y;Y;4;4;Y;Y"

        game_start.visible = false
        if ( wg_game_syno[wg_current_level][1] != "" )
        {
            game_order.fn_display_order(wg_current_level)
        }
        else
        {
            game_area.fn_next_level()
        }

        background_rotate_animator.stop()
    }

    // **************************
    // *** INTERCEPT MINIMIZE ***
    // **************************

    Connections {
        target: Qt.application
        onStateChanged:
            if(Qt.application.state == Qt.ApplicationActive)
            {
                if ( game_start.visible == false )
                {
                    game_track.play()
                }
            }
            else if(Qt.application.state == Qt.ApplicationHidden || Qt.application.state == Qt.ApplicationSuspended || Qt.application.state == Qt.ApplicationInactive)
            {
                game_track.stop()
            }
    }
}
