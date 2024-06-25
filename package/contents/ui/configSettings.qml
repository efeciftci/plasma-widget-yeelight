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
import com.efeciftci.yeelight as Yeelight

KCM.SimpleKCM {
    id: root
    property alias cfg_ipAddress: ipAddr.text
    property alias cfg_animSudden: animSudden.checked
    property alias cfg_animDuration: animDuration.value
    property var bulbList: []
    
    headerPaddingEnabled: false
    header: ColumnLayout {
        Kirigami.InlineMessage {
            id: noBulbsNotification
            Layout.fillWidth: true
            position: Kirigami.InlineMessage.Position.Header
            type: Kirigami.MessageType.Error
            text: i18n('No bulbs have been found on the local network.')
            visible: false
        }
    }
    
    Kirigami.FormLayout {
        RowLayout {
            Kirigami.FormData.label: i18n('IP address:')
            Kirigami.FormData.buddyFor: ipAddr
            QQC2.TextField {
                id: ipAddr
            }
            Kirigami.ContextualHelpButton {
                toolTipText: xi18nc('@info:whatsthis', 'IP address of the bulb. Can be filled in manually, or one can be selected via the list of bulbs displayed by the <interface>Scan Network</interface> button.')
            }
        }
        
        QQC2.Button {
            id: networkScanButton
            icon.name: 'search-symbolic'
            text: i18n("Scan Network...")
            
            onClicked: {
                root.bulbList = JSON.parse(bulbs.search())
                if (root.bulbList.length > 0)
                    discoveryDialog.open()
                else {
                    noBulbsNotification.visible = true
                    warningTimer.running = true
                }
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
    
    Kirigami.OverlaySheet {
        id: discoveryDialog    
        title: i18n('Discovered Bulbs')
        
        ListView {
            id: listView
            implicitWidth: Kirigami.Units.gridUnit * 20
            model: root.bulbList
            delegate: QQC2.RadioDelegate {
                topPadding: Kirigami.Units.smallSpacing * 2
                bottomPadding: Kirigami.Units.smallSpacing * 2
                implicitWidth: listView.width
                text: `${modelData.addr} - ${modelData.id}`
                
                onClicked: {
                    listView.currentIndex = index
                }
            }
        }
        
        footer: QQC2.DialogButtonBox {
            standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel
            onAccepted: {
                var selectedIndex = listView.currentIndex;
                if (selectedIndex >= 0) {
                    var selectedItem = listView.model[selectedIndex];
                    ipAddr.text = `${selectedItem.addr}`;
                }
                discoveryDialog.close()
            }
            onRejected: discoveryDialog.close()
        }
    }
    
    Yeelight.BulbDiscovery { id: bulbs }
    
    Timer {
        id: warningTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            noBulbsNotification.visible = false
        }
    }
}
