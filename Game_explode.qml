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

Item {
    x: 0
    y: 0
    width: 128
    height: 128
    z: 9
    AnimatedSprite {
        id: explode_sprite
        width: 128
        height: 128
        anchors.centerIn: parent
        source: "Images/explode.png"
        frameCount: 24
        frameRate: 20
        frameSync: false
        frameWidth: 256
        frameHeight: 256
        interpolate: false
        loops: 1
        running: false
    }

    function fn_start_explode()
    {
        explode_sprite.start()
        timer_boom.start()
        rock_explode.play()
    }

    Timer {
        id: timer_boom
        interval: 1200
        running: false
        repeat: false
        onTriggered: fn_boom_finished()
    }

    function fn_boom_finished()
    {
        destroy()
    }
}
