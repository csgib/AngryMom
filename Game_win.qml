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
import "Data_store.js" as Storage

Item {
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "#AA000000"
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
        width: parent.width - 60
        height: (parent.height-160) / 4
        y: 100
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        color: "#f8b1c1"
        font.pixelSize: height / 4
        font.bold: false
        wrapMode: Text.WordWrap
        text: qsTr("Vous avez gagné maman n'est plus grincheuse. Mais combien de temps cela durera t'il ?")
        z: 1
    }

    Text {
        z: 1
        id: win_temps
        width: parent.width - 60
        font.bold: false
        wrapMode: Text.WordWrap
        y: parent.height-270
        height: 100
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: ""
        color: "#FFFFFF"
        font.pixelSize: 20
    }

    Text {
        z: 1
        y: parent.height-110
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Retour")
        color: "#FFFFFF"
        font.pixelSize: 50
        MouseArea{
            anchors.fill: parent
            onClicked: {
                game_area.fn_emptyField()
                background_rotate_animator.start()
                game_start.visible = true
                game_win.visible = false
                game_track.stop()
            }
        }
    }

    function fn_display_win()
    {
        var wl_date_start = new Date()
        wl_date_start = Date.fromLocaleString(locale, Storage.get("BDATE"), "yyyyMMddHHmmss")

        var wl_date = new Date()
        wl_date = Date.fromLocaleString(locale, Qt.formatDateTime(new Date(), "yyyyMMddHHmmss"), "yyyyMMddHHmmss")

        var wl_diff_sec = wl_date.getSeconds() - wl_date_start.getSeconds()
        var wl_diff_min = wl_date.getMinutes() - wl_date_start.getMinutes()
        var wl_diff_hour = wl_date.getHours() - wl_date_start.getHours()
        var wl_diff_day = wl_date.getDay() - wl_date_start.getDay()
        var wl_diff_month = wl_date.getMonth() - wl_date_start.getMonth()
        var wl_diff_year = wl_date.getFullYear() - wl_date_start.getFullYear()

        var wl_construct_result = ""

        if ( wl_diff_year > 0 )
        {
            wl_construct_result += wl_diff_year + qsTr(" année(s) ")
        }

        if ( wl_diff_month > 0 )
        {
            wl_construct_result += wl_diff_month + qsTr(" mois ")
        }

        if ( wl_diff_day > 0 )
        {
            wl_construct_result += wl_diff_day + qsTr(" jour(s) ")
        }

        if ( wl_diff_hour > 0 )
        {
            wl_construct_result += wl_diff_hour + qsTr(" heures(s) ")
        }

        if ( wl_diff_min > 0 )
        {
            wl_construct_result += wl_diff_min + qsTr(" minute(s) ")
        }

        if ( wl_diff_sec > 0 )
        {
            wl_construct_result += wl_diff_sec + qsTr(" seconde(s) ")
        }

        win_temps.text = qsTr("Il vous a fallu") + " " + wl_construct_result

        particleSystem_success.start()
        applause.play()
        game_win.visible = true
    }
}
