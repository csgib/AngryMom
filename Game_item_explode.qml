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
    z: 1
    ParticleSystem {
        id: particleSystem
        running: false
    }

    Emitter {
        id: emitter
        anchors.fill: parent
        system: particleSystem
        emitRate: 4
        lifeSpan: 1000
        lifeSpanVariation: 0
        size: 180
    }

    ImageParticle {
        source: "Images/star.png"
        color: '#8e24aa'
        system: particleSystem
        rotation: 15
        rotationVariation: 5
        rotationVelocity: 45
        rotationVelocityVariation: 15

        entryEffect: ImageParticle.Scale
    }

    function fn_boom()
    {
        particleSystem.running = true
        timer_boom.start()
    }

    function fn_boom_finished()
    {
        destroy()
    }

    Timer {
        id: timer_boom
        interval: 1500
        running: false
        repeat: false
        onTriggered: fn_boom_finished()
    }

    NumberAnimation on opacity {
        id: fadeOutAnimation
        from: 1
        to: 0
        duration: 1400
    }
}
