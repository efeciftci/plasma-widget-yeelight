/*
 *   Copyright 2024 Efe Çiftci <efeciftci@gmail.com>
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

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_ipAddress: ipAddr.text
    property alias cfg_animSudden: animSudden.checked
    property alias cfg_animDuration: animDuration.value
    
    Kirigami.FormLayout {
        ColumnLayout {
            Kirigami.FormData.label: i18n('IP address:')
            Kirigami.FormData.buddyFor: ipAddr
            QQC2.TextField {
                id: ipAddr
            }
            QQC2.Label {
                text: 'IP address of the bulb'
            }
        }
        
        Item {
            Kirigami.FormData.isSection: true
        }
        
        ColumnLayout {
            Kirigami.FormData.label: i18n('Animation Type:')
            Kirigami.FormData.buddyFor: animSudden
            QQC2.RadioButton {
                id: animSudden
                checked: cfg_animSudden
                text: i18n('Sudden')
            }
            QQC2.RadioButton {
                id: animSmooth
                checked: !cfg_animSudden
                text: i18n('Smooth')
            }
        }
        
        Item {
            Kirigami.FormData.isSection: true
        }
        
        GridLayout {
            Kirigami.FormData.label: i18n('Animation Duration:')
            Kirigami.FormData.buddyFor: animDuration
            columns: 3
            QQC2.Slider {
                id: animDuration
                enabled: animSmooth.checked
                Layout.columnSpan: 3
                Layout.minimumWidth: ipAddr.width
                from: 100
                to: 2000
                stepSize: 100
            }
            QQC2.Label {
                text: i18n('Fast')
            }
            Item {
                Layout.fillWidth: true
            }
            QQC2.Label {
                text: i18n('Slow')
            }
        }
    }
}
