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
import QtQuick.Particles 2.0

Item {
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "#AA000000"
        z: 0
    }

    Image{
        source: "Images/coupe.png"
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        fillMode: Image.PreserveAspectFit
        y: 40
        width: parent.width
        height: parent.height - 90
        z: 0
    }

    ParticleSystem {
        id: particleSystem_success
        anchors.fill: parent
        running: false
        z: 1
    }

    Emitter {
        id: emitter
        anchors.fill: parent
        system: particleSystem_success
        emitRate: 25
        lifeSpan: 1000
        lifeSpanVariation: 0
        size: 140
        velocity: AngleDirection {
            angle: 90
            angleVariation: 15
            magnitude: 200
            magnitudeVariation: 50
        }
    }

    ImageParticle {
        source: "Images/star.png"
        color: '#FFFFFF'
        system: particleSystem_success
        redVariation: 0.2
        rotation: 15
        rotationVariation: 5
        rotationVelocity: 45
        rotationVelocityVariation: 15

        entryEffect: ImageParticle.Scale
    }

    Text {
        color: "#FFFFFF"
        font.pixelSize: 30
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Vous avez gagné")
        y: 30
        z: 1
    }

    Text {
        z: 1
        y: parent.height-110
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Continuons ...")
        color: "#FFFFFF"
        font.pixelSize: 50
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if ( wg_current_level == wg_game_syno.length )
                {
                    game_success.visible = false
                    game_win.fn_display_win()
                }
                else
                {
                    if ( wg_game_syno[wg_current_level][1] == "" )
                    {
                        game_area.fn_next_level()
                        particleSystem_success.stop()
                        game_success.visible = false
                    }
                    else
                    {
                        game_success.visible = false
                        particleSystem_success.stop()
                        game_order.fn_display_order(wg_current_level)
                    }
                }
            }
        }
    }

    function fn_display_success()
    {
        particleSystem_success.start()
        applause.play()
        game_success.visible = true
    }
}
