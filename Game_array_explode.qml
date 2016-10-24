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
import QtQuick.Particles 2.0

Item {

    id: explode_row_or_col
    x: 0
    y: 0
    z: 2
    width: 200

    property int sens: 0
    property int angle_param: 0

    Image{
        id: element_for_game
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: false
        asynchronous: true
        source: {
            if (sens == 0)
                return "Images/fireball.png"
            else if (sens == 1)
                return "Images/fireball_v.png"
        }
    }

    ParticleSystem {
        id: particleSystem
        running: true
    }

    Emitter {
        id: emitter
        anchors.fill: parent
        system: particleSystem
        emitRate: 15
        lifeSpan: 700
        lifeSpanVariation: 0
        size: 180
        velocity: AngleDirection {
            angle: angle_param
            angleVariation: 5
            magnitude: 250
            magnitudeVariation: 50
        }
    }

    ImageParticle {
        source: "Images/star.png"
        color: "#31d1fe"
        system: particleSystem
    }

    SequentialAnimation on x{
        id: xAnim
        running: false
        loops: 1
        NumberAnimation {
            from: -200
            to: myarea.width+200
            duration: 1200
            easing.type: Easing.Linear
        }
    }

    SequentialAnimation on y{
        id: yAnim
        running: false
        loops: 1
        NumberAnimation {
            from: -200
            to: myarea.height+200
            duration: 1200
            easing.type: Easing.Linear
        }
    }

    SequentialAnimation on opacity{
        id: fadeout
        running: false
        loops: 1
        NumberAnimation {
            id: fadeOutAnimation
            from: 1
            to: 0
            duration: 200
        }
        onStopped: {
            fn_boom_destroy()
        }
    }

    function fn_boom()
    {
        particleSystem.running = true
        if ( sens == 0 )
        {
            xAnim.start()
        }
        else
        {
            yAnim.start()
        }
        timer_boom.start()
    }

    function fn_boom_finished()
    {
        fadeout.start()
        particleSystem.running = false
    }

    function fn_boom_destroy()
    {
        destroy()
    }

    Timer {
        id: timer_boom
        interval: 1600
        running: false
        repeat: false
        onTriggered: fn_boom_finished()
    }
}
