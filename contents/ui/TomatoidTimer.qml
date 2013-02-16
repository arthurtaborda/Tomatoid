/*
 *   Copyright 2012 Arthur Taborda <arthur.hvt@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
// import Qt.multimedia 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

import "plasmapackage:/code/logic.js" as Logic

Item {
    property alias running: timer.running

    property int seconds // variable
    property int totalSeconds //constant

    property int taskId
    property string taskName

    signal timeout()


    onTotalSecondsChanged: {
        seconds = totalSeconds;
    }

//     Audio {
//          id: ticking
//          source: "data/tomatoid-ticking.wav"
//      }


    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true

        onTriggered: {
            console.log(seconds)
            if(seconds > 1) {
                seconds -= 1;
//                 ticking.play()
            } else {
                totalSeconds = 0;
                timeout()
            }
        }
    }
}