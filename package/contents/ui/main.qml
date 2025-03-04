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
import QtQuick.Templates as Templates
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import com.efeciftci.yeelight as Yeelight

PlasmoidItem {
	id: main
	
	property bool bulbOn: false
	property int rgbVal: 0
	
	Plasmoid.icon: bulbOn ? 'redshift-status-on' : 'redshift-status-off'
	Plasmoid.status: Plasmoid.configuration.ipAddress == '' ? PlasmaCore.Types.PassiveStatus : PlasmaCore.Types.ActiveStatus
	
	toolTipMainText: i18n('Yeelight Control')
	toolTipSubText: {
		if (bulbOn) {
			return i18n('Middle-click to toggle the bulb off')
		} else {
			return i18n('Middle-click to toggle the bulb on')
		}
	}
	
	Yeelight.Bulb {
		id: bulb
		ipAddress: Plasmoid.configuration.ipAddress
		animType: Plasmoid.configuration.animSudden ? 'sudden' : 'smooth'
		animDuration: Plasmoid.configuration.animDuration
	}
	
	function toggleBulb() {
		bulbOn = !bulbOn
		bulb.execCmd('set_power', bulbOn ? 'on' : 'off')
	}
	
	compactRepresentation: MouseArea {
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton
		onClicked: mouse => {
			if (mouse.button == Qt.LeftButton) {
				main.expanded = !main.expanded
			} else if (mouse.button == Qt.MiddleButton) {
				toggleBulb()
			}
		}
		
		Kirigami.Icon {
			anchors.fill: parent
			source: Plasmoid.icon
		}
	}
	
	fullRepresentation: PlasmaExtras.Representation {
		header: PlasmaExtras.PlasmoidHeading {
			enabled: bulbOn
			visible: Plasmoid.configuration.ipAddress != ''
			
			RowLayout {
				anchors.fill: parent
				PlasmaComponents.TabBar {
					id: tabBar
					Layout.fillWidth: true
					Layout.fillHeight: true
					
					currentIndex: {
						switch (Plasmoid.configuration.currentTab) {
							case 'white':
								return whiteTab.PlasmaComponents.TabBar.index;
							case 'color':
								return colorTab.PlasmaComponents.TabBar.index;
						}
					}
					
					onCurrentIndexChanged: {
						switch (currentIndex) {
							case whiteTab.PlasmaComponents.TabBar.index:
								bulb.execCmd('set_ct_abx', temperatureSlider.value)
								Plasmoid.configuration.currentTab = 'white';
								break;
							case colorTab.PlasmaComponents.TabBar.index:
								bulb.execCmd('set_rgb', rgbVal)
								Plasmoid.configuration.currentTab = 'color';
								break;
						}
					}
					
					PlasmaComponents.TabButton {
						id: whiteTab
						text: i18n('White')
					}
					
					PlasmaComponents.TabButton {
						id: colorTab
						text: i18n('Color')
					}
				}
			}
		}
		
		contentItem: Templates.StackView {
			id: contentView
			enabled: bulbOn || Plasmoid.configuration.ipAddress == ''
			
			ColumnLayout {
				id: whiteView
				visible: tabBar.currentIndex == whiteTab.PlasmaComponents.TabBar.index && Plasmoid.configuration.ipAddress != ''
				width: parent.width
				
				Column {
					id: whiteBrightnessColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: whiteBrightnessLabel
							Layout.fillWidth: true
							text: i18n('Brightness')
						}
						
						PlasmaComponents.Label {
							id: whiteBrightnessPercent
							horizontalAlignment: Text.AlignRight
							text: whiteBrightnessSlider.value + '%'
						}
					}
					
					PlasmaComponents.Slider {
						id: whiteBrightnessSlider
						width: parent.width
						from: 1
						to: 100
						stepSize: 1
						value: 100
						onValueChanged: {
							colorBrightnessSlider.value = whiteBrightnessSlider.value
							bulb.execCmd('set_bright', this.value)
						}
					}
				}
				
				Column {
					id: temperatureColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: temperatureLabel
							Layout.fillWidth: true
							text: i18n('Temperature')
						}
						
						PlasmaComponents.Label {
							id: temperaturePercent
							horizontalAlignment: Text.AlignRight
							text: temperatureSlider.value + 'K'
						}
					}
					
					PlasmaComponents.Slider {
						id: temperatureSlider
						width: parent.width
						from: 1700
						to: 6500
						stepSize: 100
						value: 2700
						onValueChanged: {
							if (Plasmoid.configuration.currentTab == 'white')
								bulb.execCmd('set_ct_abx', this.value)
						}
					}
				}
			}
			
			ColumnLayout {
				id: colorView
				visible: tabBar.currentIndex == colorTab.PlasmaComponents.TabBar.index && Plasmoid.configuration.ipAddress != ''
				width: parent.width
				
				Column {
					id: colorBrightnessColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: colorBrightnessLabel
							Layout.fillWidth: true
							text: i18n('Brightness')
						}
						
						PlasmaComponents.Label {
							id: colorBrightnessPercent
							horizontalAlignment: Text.AlignRight
							text: colorBrightnessSlider.value + '%'
						}
					}
					
					PlasmaComponents.Slider {
						id: colorBrightnessSlider
						width: parent.width
						from: 1
						to: 100
						stepSize: 1
						value: 100
						onValueChanged: {
							whiteBrightnessSlider.value = colorBrightnessSlider.value
						}
					}
				}
				
				Column {
					id: redColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: redLabel
							Layout.fillWidth: true
							text: i18n('Red')
						}
						
						PlasmaComponents.Label {
							id: redPercent
							horizontalAlignment: Text.AlignRight
							text: redSlider.value
						}
					}
					
					PlasmaComponents.Slider {
						id: redSlider
						width: parent.width
						from: 0
						to: 255
						stepSize: 1
						value: 255
						onValueChanged: {
							rgbVal = redSlider.value * 65536 + greenSlider.value * 256 + blueSlider.value
							if (Plasmoid.configuration.currentTab == 'color')
								bulb.execCmd('set_rgb', rgbVal)
						}
					}
				}
				
				Column {
					id: greenColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: greenLabel
							Layout.fillWidth: true
							text: i18n('Green')
						}
						
						PlasmaComponents.Label {
							id: greenPercent
							horizontalAlignment: Text.AlignRight
							text: greenSlider.value
						}
					}
					
					PlasmaComponents.Slider {
						id: greenSlider
						width: parent.width
						from: 0
						to: 255
						stepSize: 1
						value: 255
						onValueChanged: {
							rgbVal = redSlider.value * 65536 + greenSlider.value * 256 + blueSlider.value
							if (Plasmoid.configuration.currentTab == 'color')
								bulb.execCmd('set_rgb', rgbVal)
						}
					}
				}
				
				Column {
					id: blueColumn
					Layout.fillWidth: true
					
					RowLayout {
						width: parent.width
						
						PlasmaComponents.Label {
							id: blueLabel
							Layout.fillWidth: true
							text: i18n('Blue')
						}
						
						PlasmaComponents.Label {
							id: bluePercent
							horizontalAlignment: Text.AlignRight
							text: blueSlider.value
						}
					}
					
					PlasmaComponents.Slider {
						id: blueSlider
						width: parent.width
						from: 0
						to: 255
						stepSize: 1
						value: 255
						onValueChanged: {
							rgbVal = redSlider.value * 65536 + greenSlider.value * 256 + blueSlider.value
							if (Plasmoid.configuration.currentTab == 'color')
								bulb.execCmd('set_rgb', rgbVal)
						}
					}
				}
			}
		}
		
		footer: PlasmaExtras.PlasmoidHeading {
			height: parent.header.height
			visible: Plasmoid.configuration.ipAddress != ''
			
			PlasmaComponents.CheckBox {
				id: onOffCheckBox
				anchors.leftMargin: Kirigami.Units.smallSpacing
				anchors.verticalCenter: parent.verticalCenter
				
				text: i18n('Turned On')
				checked: bulbOn
				onToggled: toggleBulb()
			}
		}
		
		PlasmaExtras.PlaceholderMessage {
			id: noBulbsPlaceholder
			anchors.centerIn: parent
			width: parent.width - (Kirigami.Units.gridUnit * 4)
			visible: Plasmoid.configuration.ipAddress == ''
			text: i18n('No bulbs have been configured yet')
			iconName: 'redshift-status-off'
			
			helpfulAction: QQC2.Action {
				text: i18n('Configure')
				icon.name: "configure"
				onTriggered: Plasmoid.internalAction("configure").trigger()
			}
		}
		
		Component.onCompleted: refreshUI()
		
		Timer {
			interval: 5000
			running: true
			repeat: true
			onTriggered: refreshUI()
		}
		
		function refreshUI() {
			if (Plasmoid.configuration.ipAddress != '') {
				var results = JSON.parse(bulb.fetchBulbState()).result
				
				bulbOn = (results[0] == 'on')
				Plasmoid.configuration.currentTab = results[2] == '1' ? 'color' : 'white'
				
				whiteBrightnessSlider.value = results[1]
				temperatureSlider.value = results[3]
				
				redSlider.value = Math.floor(results[4] / 65536)
				greenSlider.value = Math.floor((results[4] % 65536) / 256)
				blueSlider.value = results[4] % 256
			}
		}
	}
}
