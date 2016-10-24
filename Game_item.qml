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
import QtGraphicalEffects 1.0

Item {
    id: element_ID
    // *** PROPERIES OF OBJECT ***
    property int type
    property int type_icon
    property int column
    property int row

    property int start_drag_x
    property int start_drag_y
    property int drag_direction

    property int super_ball

    property int callback_anim

    property int fall_y
    property int old_fall_y

    property int count_explode: 0 // *** USE ONLY FOR ROCK ***

    z: 0

    signal released(int drag_direction, int column, int row)

    // *** DEFAULT PARAMETERS OF ELEMENT ***
    width: parent.width / 6
    height: parent.height / 8

    Image{
        id: element_for_game
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: false
        asynchronous: true
        source: {
            if ( type_icon == 0 )
            {
                if (type == 0)
                    return "Images/astro_001.png"
                else if(type == 1)
                    return "Images/astro_002.png"
                else if(type == 2)
                    return "Images/astro_003.png"
                else if(type == 3)
                    return "Images/astro_004.png"
                else if(type == 4)
                    return "Images/astro_010.png"
                else if(type == 5)
                    return "Images/bomb.png"
                else if(type == 9)
                    return "Images/astro_009.png"
            }
            else
            {
                if ( type_icon == 1 )
                {
                    if (type == 0)
                        return "Images/astro_005.png"
                    else if(type == 1)
                        return "Images/astro_006.png"
                    else if(type == 2)
                        return "Images/astro_007.png"
                    else if(type == 3)
                        return "Images/astro_008.png"
                    else if(type == 4)
                        return "Images/astro_010.png"
                    else if(type == 5)
                        return "Images/bomb.png"
                    else if(type == 9)
                        return "Images/astro_009.png"
                }
                else
                {
                    if (type == 0)
                        return "Images/astro_011.png"
                    else if(type == 1)
                        return "Images/astro_012.png"
                    else if(type == 2)
                        return "Images/astro_013.png"
                    else if(type == 3)
                        return "Images/astro_014.png"
                    else if(type == 4)
                        return "Images/astro_010.png"
                    else if(type == 5)
                        return "Images/bomb.png"
                    else if(type == 9)
                        return "Images/astro_015.png"
                }
            }

        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                start_drag_x = mouseX
                start_drag_y = mouseY
                drag_direction = 9
            }
            onPositionChanged: {
                if ( Math.abs(mouseX-start_drag_x) > Math.abs(mouseY-start_drag_y) )
                {
                    // *** DEPLACEMENT HORIZONTAL ***
                    if ( Math.abs(mouseX-start_drag_x) > 10 )
                    {
                        if ( (mouseX-start_drag_x) > 0 )
                        {
                            drag_direction = 0
                        }
                        else
                        {
                            drag_direction = 1
                        }
                    }
                }
                else
                {
                    // *** DEPLACEMENT VERTICAL ***
                    if ( Math.abs(mouseY-start_drag_y) > 10 )
                    {
                        if ( (mouseY-start_drag_y) > 0 )
                        {
                            drag_direction = 2
                        }
                        else
                        {
                            drag_direction = 3
                        }
                    }
                }
            }
            onReleased: {
                element_ID.released(drag_direction, column, row)
            }
        }

        NumberAnimation on opacity {
            id: createAnimation
            from: 0
            to: 1
            duration: 400
        }

        Component.onCompleted: {
            if ( super_ball > 0 )
            {
                item_glow.visible = true
            }
            createAnimation.start()
        }
    }

    Glow {
        id: item_glow
        anchors.fill: element_for_game
        radius: 8
        samples: 10
        color: "#ea80fc"
        source: element_for_game
        visible: false
    }

    Colorize {
        id: item_rock_step_2
        anchors.fill: element_for_game
        source: element_for_game
        hue: 0.0
        saturation: 0.5
        lightness: -0.2
        visible: false
    }

    PropertyAnimation{
        id: anim_move_item_left
        target: element_ID
        easing.type: Easing.InOutCubic
        properties: "x"
        from: element_ID.x
        to: element_ID.x-element_ID.width
        duration: 300
        onRunningChanged: if (!running) fn_animationCompleted()
    }

    PropertyAnimation{
        id: anim_move_item_right
        target: element_ID
        easing.type: Easing.InOutCubic
        properties: "x"
        from: element_ID.x
        to: element_ID.x+element_ID.width
        duration: 300
        onRunningChanged: if (!running) fn_animationCompleted()
    }

    PropertyAnimation{
        id: anim_move_item_top
        target: element_ID
        easing.type: Easing.InOutCubic
        properties: "y"
        from: element_ID.y
        to: element_ID.y-element_ID.height
        duration: 300
        onRunningChanged: if (!running) fn_animationCompleted()
    }

    PropertyAnimation{
        id: anim_move_item_bottom
        target: element_ID
        easing.type: Easing.InOutCubic
        properties: "y"
        from: element_ID.y
        to: element_ID.y+element_ID.height
        duration: 300
        onRunningChanged: if (!running) fn_animationCompleted()
    }

    PropertyAnimation{
        id: anim_fall_item_bottom
        target: element_ID
        easing.type: Easing.InOutCubic
        properties: "y"
        from: old_fall_y
        to: fall_y
        duration: 250
    }

    function fn_fall_item_bottom(old_y, y) {
        fall_y = y
        old_fall_y = old_y
        anim_fall_item_bottom.start()
    }

    function fn_move_item_left(wl_callback_anim) {
        callback_anim = wl_callback_anim
        anim_move_item_left.start()
    }

    function fn_move_item_right(wl_callback_anim) {
        callback_anim = wl_callback_anim
        anim_move_item_right.start()
    }

    function fn_move_item_top(wl_callback_anim) {
        callback_anim = wl_callback_anim
        anim_move_item_top.start()
    }

    function fn_move_item_bottom(wl_callback_anim) {
        callback_anim = wl_callback_anim
        anim_move_item_bottom.start()
    }

    function fn_rock_step_2()
    {
        item_rock_step_2.visible = true
    }

    function fn_remove()
    {
        destroy()
    }

    function fn_animationCompleted()
    {
        if ( callback_anim === 1 )
        {
            game_area.fn_explode_items()
        }
    }
}
