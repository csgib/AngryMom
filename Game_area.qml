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
    anchors.fill: parent
    visible: false

    Rectangle{
        id: game_area_header
        color: "#ffdbea"
        x: 0
        y: 0
        height: 80
        width: parent.width

        Image{
            x: parent.width - 250
            y: 0
            width: 250
            height: 80
            fillMode: Image.PreserveAspectFit
            smooth: false
            asynchronous: true
            source: "Images/bg_header.png"
        }

        Text{
            id: game_area_header_score
            color: "#FFFFFF"
            font.pixelSize: 60
            x: 140
            y: 5
            width: parent.width - 150
            text: "0"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        Glow {
            anchors.fill: game_area_header_score
            radius: 2
            samples: 10
            color: "#000000"
            source: game_area_header_score
            visible: true
        }

        Image{
            x: 8
            y: 8
            width: 60
            height: 60
            fillMode: Image.PreserveAspectFit
            smooth: false
            asynchronous: true
            source: "Images/restart.png"
            horizontalAlignment: Text.AlignHCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if ( lock_mvt == 0 )
                    {
                        game_area.visible = false
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
                        game_score_hit.fn_hide_hit()
                        game_area.game_score = 0

                        game_area.visible = true
                    }
                }
            }
        }

        Image{
            x: 76
            y: 8
            width: 60
            height: 60
            fillMode: Image.PreserveAspectFit
            smooth: false
            asynchronous: true
            source: "Images/shutdown.png"
            horizontalAlignment: Text.AlignHCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    game_area.fn_emptyField()
                    background_rotate_animator.start()
                    game_start.visible = true
                    game_area.visible = false
                    game_track.stop()
                }
            }
        }

        Rectangle{
            id: pb_time
            x: 0
            y: 76
            width: parent.width
            height: 4
            color: "#f0422b"
        }
    }

    Rectangle{
        id: game_area_board
        x: 0
        y: 80
        z: 0
        height: parent.height - 80
        width: parent.width
        color: "#DDFFFFFF"

        Game_score_hit {
            id: game_score_hit
            z: 2
        }

        Item {
            id: game_area_board_content
            anchors.fill: parent
            z: 1
        }
    }

    // *** PROPERTIES OF CURRENT GAMEBOARD ***
    property int rows: 8
    property int columns: 6
    property var field: []
    property var explode_field: []
    property int explode_number: 0
    property int time_remaining: 60
    property int game_score: 0
    property int lock_mvt: 0
    property int wg_search_y: 0
    property int wg_compteur: 0
    property int wg_type: 0
    property int wg_super: 0
    property int wg_count_move: 1

    property var wg_item: Qt.createComponent('Game_item.qml')
    property var wg_item_boom_array: Qt.createComponent('Game_array_explode.qml')
    property var wg_item_boom: Qt.createComponent('Game_item_explode.qml')
    property var wg_item_explode: Qt.createComponent('Game_explode.qml')

    // *************************
    // *** TIMER OF THE GAME ***
    // *************************
    Timer {
        id: timer_game
        interval: 1000
        running: false
        repeat: true
        onTriggered: fn_time_compute()
    }

    function fn_time_compute()
    {
        time_remaining -= 1

        if ( time_remaining <= 0 )
        {
            timer_game.stop()
            pb_time.width = 0
            rire.play()
            game_area.visible = false
            game_failed.visible = true
        }
        else
        {
            pb_time.width = (time_remaining*parent.width)/wg_game_syno[wg_current_level][3]
        }
    }

    // ************************
    // *** INITIALIZE BOARD ***
    // ************************
    function fn_initializeField(wl_start_idx)
    {
        field.length = 0
        wg_count_move = 1

        for(var i = wl_start_idx*8; i < ((wl_start_idx*8)+8); i++)
        {
            var wl_type = field_level[i].split(';')

            field[i-(wl_start_idx*8)] = new Array(columns);
            for(var j = 0; j < columns; j++)
            {
                if ( wl_type[j] != "Y" )
                {
                    field[i-(wl_start_idx*8)][j] = fn_createBlock(i-(wl_start_idx*8), j, wl_type[j])
                }
                else
                {
                    field[i-(wl_start_idx*8)][j] = fn_createBlock_random(i-(wl_start_idx*8), j)
                }
            }
        }

        fn_search_to_delete()
        timer_game.start()
    }

    function fn_initializeField_random()
    {
        field.length = 0
        wg_count_move = 1

        for(var i = 0; i < rows; i++)
        {
            field[i] = new Array(columns);
            for(var j = 0; j < columns; j++)
            {
                field[i][j] = fn_createBlock_random(i, j)
            }
        }

        fn_search_to_delete()
        timer_game.start()
    }

    // *** ITEM GAME CREATION ***
    function fn_createBlock(row, column, type)
    {
        var wl_item_object = wg_item.createObject(game_area_board_content,{"type": type, "row": row, "column": column, "x": column*(game_area_board.width/columns), "y": row*(game_area_board.height/rows), "super_ball": 0, "type_icon": wg_game_syno[wg_current_level][4] })

        wl_item_object.released.connect(fn_handleGrab)
        return wl_item_object
    }

    function fn_createBlock_random(row, column)
    {
        if ( Math.floor(Math.random() * 100) > 98 && wg_count_move%3 == 0 )
        {
            wg_type = 5
            wg_super = 0
        }
        else
        {
            wg_type = Math.floor(Math.random() * 4)
            if ( Math.floor(Math.random() * 10) > 8 )
            {
                wg_super = 1
            }
            else
            {
                wg_super = 0
            }
        }

        var wl_item_object = wg_item.createObject(game_area_board_content,{"type": wg_type, "row": row, "column": column, "x": column*(game_area_board.width/columns), "y": row*(game_area_board.height/rows), "super_ball": wg_super, "type_icon": wg_game_syno[wg_current_level][4] })

        wl_item_object.released.connect(fn_handleGrab)
        return wl_item_object
    }

    function fn_handleGrab(drag_direction, column, row)
    {
        if ( lock_mvt > 0 )
        {
            return false
        }

        lock_mvt = 1

        if ( field[row][column].type == 5 )
        {
            // *** BOMB EXPLODE ***

            var wl_start_x
            var wl_start_y
            var wl_end_x
            var wl_end_y

            if ( column > 1 )
            {
                wl_start_x = column - 1
            }
            else
            {
                wl_start_x = 0
            }

            if ( column < columns-1 )
            {
                wl_end_x = column + 1
            }
            else
            {
                wl_end_x = columns-1
            }

            if ( row > 1 )
            {
                wl_start_y = row - 1
            }
            else
            {
                wl_start_y = 0
            }

            if ( row < rows-1 )
            {
                wl_end_y = row + 1
            }
            else
            {
                wl_end_y = rows-1
            }

            var wl_item_boom = wg_item_explode.createObject(game_area_board_content,{"x": field[row][column].x, "y": field[row][column].y, "width":field[row][column].width, "height": field[row][column].height })
            wl_item_boom.fn_start_explode()

            for(var i = wl_start_y; i <= wl_end_y; i++)
            {
                for(var j = wl_start_x; j <= wl_end_x; j++)
                {
                    if ( field[i][j] != "E" )
                    {
                        if ( field[i][j].type < 4 || field[i][j].type == 5 )
                        {
                            field[i][j].fn_remove()
                            field[i][j] = "E"
                        }
                    }
                }
            }

            rock_explode.play()

            game_score_hit.fn_show_hit(350)
            game_score = game_score + 350
            game_area_header_score.text = game_score

            fn_skyfall()

            return true
        }

        if ( drag_direction !== 9 && field[row][column] != "E" && field[row][column].type < 6 )
        {
            explode_number = 0

            var wl_item = field[row][column]

            switch(drag_direction)
            {
                case 0:
                    if ( column + 1 <= columns && field[row][column+1] != "E" && field[row][column+1].type < 6 )
                    {
                        var wl_item_inverse = field[row][column+1]

                        wl_item_inverse.column = wl_item.column
                        wl_item.column = wl_item.column + 1
                        field[row][column] = wl_item_inverse;
                        field[row][column+1] = wl_item;

                        if ( fn_is_move_ok(wl_item, wl_item_inverse) === true )
                        {
                            wl_item.fn_move_item_right(0)
                            wl_item_inverse.fn_move_item_left(1)

                            wg_count_move++
                        }
                        else
                        {
                            wl_item_inverse.column = wl_item.column
                            wl_item.column = wl_item.column - 1

                            field[row][column+1] = wl_item_inverse;
                            field[row][column] = wl_item;

                            lock_mvt = 0
                        }
                    }
                    else
                    {
                        lock_mvt = 0
                    }

                    break;
                case 1:
                    if ( column - 1 >= 0 && field[row][column-1] != "E" && field[row][column-1].type < 6 )
                    {
                        var wl_item_inverse = field[row][column-1]

                        wl_item_inverse.column = wl_item.column
                        wl_item.column = wl_item.column - 1
                        field[row][column] = wl_item_inverse;
                        field[row][column-1] = wl_item;

                        if ( fn_is_move_ok(wl_item, wl_item_inverse) === true )
                        {
                            wl_item_inverse.fn_move_item_right(0)
                            wl_item.fn_move_item_left(1)

                            wg_count_move++
                        }
                        else
                        {
                            wl_item_inverse.column = wl_item.column
                            wl_item.column = wl_item.column + 1

                            field[row][column-1] = wl_item_inverse;
                            field[row][column] = wl_item;

                            lock_mvt = 0
                        }
                    }
                    else
                    {
                        lock_mvt = 0
                    }

                    break;
                case 2:
                    if ( row + 1 <= rows && field[row+1][column] != "E" && field[row+1][column].type < 6 )
                    {
                        var wl_item_inverse = field[row+1][column]

                        wl_item_inverse.row = wl_item.row
                        wl_item.row = wl_item.row + 1
                        field[row][column] = wl_item_inverse;
                        field[row+1][column] = wl_item;

                        if ( fn_is_move_ok(wl_item, wl_item_inverse) === true )
                        {
                            wl_item.fn_move_item_bottom(0)
                            wl_item_inverse.fn_move_item_top(1)

                            wg_count_move++
                        }
                        else
                        {
                            wl_item_inverse.row = wl_item.row
                            wl_item.row = wl_item.row - 1

                            field[row+1][column] = wl_item_inverse;
                            field[row][column] = wl_item;

                            lock_mvt = 0
                        }
                    }
                    else
                    {
                        lock_mvt = 0
                    }

                    break;
                case 3:
                    if ( row - 1 >= 0 && field[row-1][column] != "E" && field[row-1][column].type < 6 )
                    {
                        var wl_item_inverse = field[row-1][column]

                        wl_item_inverse.row = wl_item.row
                        wl_item.row = wl_item.row - 1
                        field[row][column] = wl_item_inverse;
                        field[row-1][column] = wl_item;

                        if ( fn_is_move_ok(wl_item, wl_item_inverse) === true )
                        {
                            wl_item_inverse.fn_move_item_bottom(0)
                            wl_item.fn_move_item_top(1)

                            wg_count_move++
                        }
                        else
                        {
                            wl_item_inverse.row = wl_item.row
                            wl_item.row = wl_item.row + 1

                            field[row-1][column] = wl_item_inverse;
                            field[row][column] = wl_item;

                            lock_mvt = 0
                        }
                    }
                    else
                    {
                        lock_mvt = 0
                    }

                    break;
            }
        }
        else
        {
            lock_mvt = 0
        }
    }

    function fn_is_move_ok(wl_item, wl_item_inverse)
    {
        // *********************************************
        // *** CONTROL IF THERE IS BLOCKS TO EXPLODE ***
        // *** IF NO WE RETURN FALSE SO WE CANCEL    ***
        // *** THE MOVE                              ***
        // *********************************************
        var wl_idx_block = 0
        var wl_start_x = 0
        var wl_start_y = 0
        var wl_start_type = 0
        var wl_current_x = 0
        var wl_current_y = 0
        var wl_start_item
        var wl_current_item
        var wl_count_explode = 0

        explode_number = 0

        while ( wl_idx_block < 2 )
        {
            if ( wl_idx_block == 0 )
            {
                wl_start_x = wl_item.row
                wl_start_y = wl_item.column
                wl_start_type = wl_item.type

                wl_start_item = wl_item
            }
            else
            {
                wl_start_x = wl_item_inverse.row
                wl_start_y = wl_item_inverse.column
                wl_start_type = wl_item_inverse.type

                wl_start_item = wl_item_inverse
            }

            // *** LOOK TO THE RIGHT ***
            wl_current_x = wl_start_x
            wl_current_y = wl_start_y
            wl_current_item = field[wl_start_x][wl_start_y]
            wl_count_explode = 0

            while ( wl_start_type == wl_current_item.type && wl_current_y < columns )
            {
                wl_count_explode++
                explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                wl_current_y++

                if ( wl_current_y < columns )
                {
                    wl_current_item = field[wl_current_x][wl_current_y]
                }
            }

            // *** LOOK TO THE LEFT ***
            wl_current_x = wl_start_x
            wl_current_y = wl_start_y
            wl_current_item = field[wl_start_x][wl_start_y]

            while ( wl_start_type == wl_current_item.type && wl_current_y >= 0 )
            {
                wl_count_explode++
                explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                wl_current_y--

                if ( wl_current_y >= 0 )
                {
                    wl_current_item = field[wl_current_x][wl_current_y]
                }
            }

            if ( (wl_count_explode-1) >= 3 )
            {
                explode_number += wl_count_explode
            }

            // *** LOOK TO THE TOP ***
            wl_current_x = wl_start_x
            wl_current_y = wl_start_y
            wl_current_item = field[wl_start_x][wl_start_y]
            wl_count_explode = 0

            while ( wl_start_type == wl_current_item.type && wl_current_x >= 0 )
            {
                wl_count_explode++
                explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                wl_current_x--

                if ( wl_current_x >= 0 )
                {
                    wl_current_item = field[wl_current_x][wl_current_y]
                }
            }

            // *** LOOK TO THE BOTTOM ***
            wl_current_x = wl_start_x
            wl_current_y = wl_start_y
            wl_current_item = field[wl_start_x][wl_start_y]

            while ( wl_start_type == wl_current_item.type && wl_current_x < rows )
            {
                wl_count_explode++
                explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                wl_current_x++

                if ( wl_current_x < rows )
                {
                    wl_current_item = field[wl_current_x][wl_current_y]
                }
            }

            if ( (wl_count_explode-1) >= 3 )
            {
                explode_number += wl_count_explode
            }

            // *** LOOP ***
            wl_idx_block++
        }

        // *** BLOCK TO EXPLODE ? ***
        if ( explode_number > 0 )
        {
            return true
        }
        else
        {
            return false
        }
    }

    function fn_explode_items()
    {
        var wl_idx = 1
        var wl_heart_explode = 0

        while ( wl_idx <= explode_number )
        {            
            var wl_coord = explode_field[wl_idx].split(';')
            var wl_field = field[wl_coord[0]][wl_coord[1]]

            if ( wl_field != "E" )
            {
                // *** IF SUPERBALL LOOP TO EXPLODE ALL THE LINE OR ROW ***
                if ( wl_field.super_ball > 0 )
                {
                    if ( Math.random() > 0.6 )
                    {
                        var wl_item_object_boom = wg_item_boom_array.createObject(game_area_board_content,{"angle_param": 180, "sens": 0, "y": wl_field.y, "height": wl_field.height, "width": 200 })
                        wl_item_object_boom.fn_boom()

                        // *** EXPLODE HORIZONTAL ***
                        wg_search_y = 0
                        while ( wg_search_y < columns )
                        {
                            var wl_field_search = field[wl_coord[0]][wg_search_y]
                            if ( wl_field_search != "E" )
                            {
                                if ( wl_field_search.type < 4 )
                                {
                                    wl_field_search.fn_remove()
                                    field[wl_coord[0]][wg_search_y] = "E"
                                }
                                else
                                {
                                    if ( wl_field_search.type == 9 )
                                    {
                                        field[wl_coord[0]][wg_search_y].count_explode++
                                        if ( field[wl_coord[0]][wg_search_y].count_explode == 2 )
                                        {
                                            var wl_item_boom = wg_item_explode.createObject(game_area_board_content,{"x": wl_field_search.x, "y": wl_field_search.y, "width": wl_field_search.width, "height": wl_field_search.height })
                                            wl_item_boom.fn_start_explode()
                                            plop.play()
                                            wl_field_search.fn_remove()

                                            field[wl_coord[0]][wg_search_y] = "E"
                                        }
                                        else
                                        {
                                            wl_field_search.fn_rock_step_2()
                                        }
                                    }
                                }
                            }
                            wg_search_y++
                        }
                    }
                    else
                    {
                        var wl_item_object_boom = wg_item_boom_array.createObject(game_area_board_content,{"angle_param": 270, "sens": 1, "x": wl_field.x, "width": wl_field.width, "height": 200 })
                        wl_item_object_boom.fn_boom()

                        // *** EXPLODE VERTICAL ***
                        wg_search_y = 0
                        while ( wg_search_y < rows )
                        {
                            var wl_field_search = field[wg_search_y][wl_coord[1]]
                            if ( wl_field_search != "E" )
                            {
                                if ( wl_field_search.type < 4 )
                                {
                                    plop.play()
                                    wl_field_search.fn_remove()
                                    field[wg_search_y][wl_coord[1]] = "E"
                                }
                                else
                                {
                                    if ( wl_field_search.type == 9 )
                                    {
                                        field[wg_search_y][wl_coord[1]].count_explode++

                                        if ( field[wg_search_y][wl_coord[1]].count_explode >= 2 )
                                        {
                                            var wl_item_boom = wg_item_explode.createObject(game_area_board_content,{"x": wl_field_search.x, "y": wl_field_search.y, "width": wl_field_search.width, "height": wl_field_search.height })
                                            wl_item_boom.fn_start_explode()

                                            wl_field_search.fn_remove()

                                            field[wg_search_y][wl_coord[1]] = "E"
                                        }
                                        else
                                        {
                                            wl_field_search.fn_rock_step_2()
                                        }
                                    }
                                }
                            }

                            wg_search_y++
                        }
                    }
                }
                else
                {
                    if ( wl_field.type == 4 )
                    {
                        wl_heart_explode++
                    }

                    if ( wl_idx%2 == 0 )
                    {
                        var wl_item_object_boom = wg_item_boom.createObject(game_area_board_content,{"x": field[wl_coord[0]][wl_coord[1]].x, "y": field[wl_coord[0]][wl_coord[1]].y, "width": field[wl_coord[0]][wl_coord[1]].width, "height": field[wl_coord[0]][wl_coord[1]].height })
                        wl_item_object_boom.fn_boom()
                    }

                    plop.play()
                    wl_field.fn_remove()
                    field[wl_coord[0]][wl_coord[1]] = "E"
                }
            }
            wl_idx++
        }

        if ( wl_heart_explode > 0 )
        {
            game_score = game_score + 99999
        }
        else
        {
            game_score_hit.fn_show_hit((10*explode_number))
            game_score = game_score + (10*explode_number)
        }
        game_area_header_score.text = game_score

        if ( game_score >= wg_game_syno[wg_current_level][2] )
        {
            timer_game.stop()
            game_area.visible = false
            game_success.fn_display_success()

            wg_current_level++
        }
        else
        {
            fn_skyfall()
        }
    }   

    function fn_skyfall()
    {
        wg_compteur = 0

        for(var i = rows-1; i >= 0; i--)
        {
            for(var j = columns-1; j >= 0; j--)
            {
                if ( field[i][j] === "E" )
                {
                    wg_search_y = i
                    while ( field[wg_search_y][j] === "E" && wg_search_y >= 0 )
                    {
                        wg_search_y--
                        if ( wg_search_y < 0 )
                        {
                            break
                        }
                    }

                    if ( wg_search_y >= 0 )
                    {
                        if ( field[wg_search_y][j].type < 6 )
                        {
                            field[i][j] = field[wg_search_y][j]
                            field[wg_search_y][j] = "E"

                            field[i][j].fn_fall_item_bottom(field[i][j].y,i*field[i][j].height)
                            field[i][j].y = i*field[i][j].height
                            field[i][j].row = i

                            wg_compteur++
                        }
                    }
                    else
                    {
                        field[i][j] = fn_createBlock_random(0, j)
                        if ( i > 0 )
                        {
                            field[i][j].fn_fall_item_bottom(0, i*field[i][j].height)
                            field[i][j].row = i
                            field[i][j].y = i*field[i][j].height
                        }
                        wg_compteur++
                    }
                }
            }
        }

        if ( wg_compteur > 0 )
        {
            timer_search_delete.start()
        }
        else
        {
            lock_mvt = 0
        }
    }

    Timer {
        id: timer_search_delete
        interval: 300
        running: false
        repeat: false
        onTriggered: fn_search_to_delete()
    }

    function fn_search_to_delete()
    {
        var wl_current_x
        var wl_current_y

        var wl_start_type
        var wl_current_item
        var wl_count_explode

        explode_number = 0

        for(var i = 0; i < rows; i++)
        {
            for(var j = 0; j < columns; j++)
            {
                if ( field[i][j] != "E" && field[i][j].type < 5 )
                {
                    wl_start_type = field[i][j].type

                    // *** LOOK TO THE RIGHT ***
                    wl_current_x = i
                    wl_current_y = j
                    wl_current_item = field[i][j]
                    wl_count_explode = 0

                    while ( wl_start_type === wl_current_item.type && wl_current_y < columns )
                    {
                        wl_count_explode++
                        explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                        wl_current_y++

                        if ( wl_current_y < columns )
                        {
                            wl_current_item = field[wl_current_x][wl_current_y]
                        }
                    }

                    if ( wl_count_explode >= 3 )
                    {
                        explode_number += wl_count_explode
                    }

                    // *** LOOK TO THE LEFT ***
                    wl_current_y = j
                    wl_current_item = field[i][j]
                    wl_count_explode = 0

                    while ( wl_start_type === wl_current_item.type && wl_current_y >= 0 )
                    {
                        wl_count_explode++
                        explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                        wl_current_y--

                        if ( wl_current_y >= 0 )
                        {
                            wl_current_item = field[wl_current_x][wl_current_y]
                        }
                    }

                    if ( wl_count_explode >= 3 )
                    {
                        explode_number += wl_count_explode
                    }

                    // *** LOOK TO THE TOP ***
                    wl_current_x = i
                    wl_current_y = j
                    wl_current_item = field[i][j]
                    wl_count_explode = 0

                    while ( wl_start_type === wl_current_item.type && wl_current_x >= 0 )
                    {
                        wl_count_explode++
                        explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                        wl_current_x--

                        if ( wl_current_x >= 0 )
                        {
                            wl_current_item = field[wl_current_x][wl_current_y]
                        }
                    }

                    if ( wl_count_explode >= 3 )
                    {
                        explode_number += wl_count_explode
                    }

                    // *** LOOK TO THE BOTTOM ***
                    wl_current_x = i
                    wl_current_item = field[i][j]
                    wl_count_explode = 0

                    while ( wl_start_type === wl_current_item.type && wl_current_x < rows )
                    {
                        wl_count_explode++
                        explode_field[(explode_number + wl_count_explode)] = wl_current_x + ";" + wl_current_y

                        wl_current_x++

                        if ( wl_current_x < rows )
                        {
                            wl_current_item = field[wl_current_x][wl_current_y]
                        }
                    }

                    if ( wl_count_explode >= 3 )
                    {
                        explode_number += wl_count_explode
                    }
                }
            }
        }

        // *** BLOCK TO EXPLODE ? ***

        if ( explode_number > 0 )
        {
            fn_explode_items()
        }
        else
        {
            lock_mvt = 0
        }
    }

    // *******************
    // *** EMPTY BOARD ***
    // *******************
    function fn_emptyField()
    {
        if ( typeof field[0] !== 'undefined' )
        {
            for(var i = 0; i < rows; i++)
            {
                for(var j = 0; j < columns; j++)
                {
                    if ( field[i][j] != "E" )
                    {
                        field[i][j].fn_remove()
                        field[i][j] = "E"
                    }
                }
            }
        }
    }

    // ***************************
    // *** FUNCTION NEXT LEVEL ***
    // ***************************
    function fn_next_level()
    {
        if ( typeof field[0] !== 'undefined' )
        {
            fn_emptyField()
        }
        game_area.time_remaining = wg_game_syno[wg_current_level][3]
        game_area.game_score = 0
        game_area_header_score.text = 0

        if ( wg_game_syno[wg_current_level][0] == "N" )
        {
            game_area.fn_initializeField_random()
        }
        else
        {
            game_area.fn_initializeField(wg_game_syno[wg_current_level][0])
        }

        game_area.visible = true
        Storage.set("LEVEL", wg_current_level)

        if ( wg_current_level > 0 )
        {
            game_start.fn_display_continue()
        }
    }

    function fn_get_actual_level()
    {
        return Storage.get("LEVEL", 0)
    }
}
