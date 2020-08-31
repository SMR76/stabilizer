/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

Control {
    id: control

    width: 200
    height: width

    readonly property alias background: dialBackground
    readonly property alias handle: dialHandle

    NeumorphismDialBackground {
        id: dialBackground
        anchors.fill: control
    }

    NeumorphismDialIndicaor {
        id: dialHandle
        width: parent.width - 10
        height: width
        anchors.centerIn: parent
    }


    activeFocusOnTab: true
    /*!
        \qmlproperty real Dial::value
        The angle of the handle along the dial, in the range of
        \c 0.0 to \c 1.0.
        The default value is \c{0.0}.
    */
    property alias value: range.value

    /*!
        \qmlproperty real Dial::minimumValue
        The smallest value allowed by the dial.
        The default value is \c{0.0}.
        \sa value, maximumValue
    */
    property alias minimumValue: range.minimumValue

    /*!
        \qmlproperty real Dial::maximumValue
        The largest value allowed by the dial.
        The default value is \c{1.0}.
        \sa value, minimumValue
    */
    property alias maximumValue: range.maximumValue

    /*!
        \qmlproperty real Dial::hovered
        This property holds whether the button is being hovered.
    */
    readonly property alias hovered: mouseArea.containsMouse

    /*!
        \qmlproperty real Dial::stepSize
        The default value is \c{0.0}.
    */
    property alias stepSize: range.stepSize

    /*!
        \internal
        Determines whether the dial can be freely rotated past the zero marker.
        The default value is \c false.
    */
    property bool __wrap: false

    /*!
        This property specifies whether the dial should gain active focus when
        pressed.
        The default value is \c false.
        \sa pressed
    */
    property bool activeFocusOnPress: false

    /*!
        \qmlproperty bool Dial::pressed
        Returns \c true if the dial is pressed.
        \sa activeFocusOnPress
    */
    readonly property alias pressed: mouseArea.pressed

    /*!
        This property determines whether or not the dial displays tickmarks,
        minor tickmarks, and labels.
        For more fine-grained control over what is displayed, the following
        style components of
        \l {DialStyle} can be used:
        \list
            \li \l {DialStyle::}{tickmark}
            \li \l {DialStyle::}{minorTickmark}
            \li \l {DialStyle::}{tickmarkLabel}
        \endlist
        The default value is \c true.
    */
    property bool tickmarksVisible: true

    Keys.onLeftPressed: value -= stepSize
    Keys.onDownPressed: value -= stepSize
    Keys.onRightPressed: value += stepSize
    Keys.onUpPressed: value += stepSize

    RangeModel {
        id: range
        minimumValue: 0.0
        maximumValue: 1.0
        stepSize: 0
        value: 0
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: background

        onPositionChanged: {
            if (pressed) {
                value = valueFromPoint(mouseX, mouseY);
            }
        }
        onPressed: {
            if (!__style.__dragToSet)
                value = valueFromPoint(mouseX, mouseY);

            if (activeFocusOnPress)
                dial.forceActiveFocus();
        }

        function bound(val) { return Math.max(minimumValue, Math.min(maximumValue, val)); }

        function valueFromPoint(x, y)
        {
            var yy = height / 2.0 - y;
            var xx = x - width / 2.0;
            var angle = (xx || yy) ? Math.atan2(yy, xx) : 0;

            if (angle < Math.PI/ -2)
                angle = angle + Math.PI * 2;

            var range = maximumValue - minimumValue;
            var value;
            if (__wrap)
                value = (minimumValue + range * (Math.PI * 3 / 2 - angle) / (2 * Math.PI));
            else
                value = (minimumValue + range * (Math.PI * 4 / 3 - angle) / (Math.PI * 10 / 6));

            return bound(value)
        }
    }
}
