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
import QtQuick.Layouts
import org.kde.plasma.core as PC
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.extras as PE
import org.kde.plasma.components as PC
import QtQuick.Templates as T

PlasmoidItem {
	id: main
	
	property bool bulbOn: false
	
	Plasmoid.icon: {
		if (bulbOn) {
			return 'redshift-status-on'
		} else {
			return 'redshift-status-off'
		}
	}
	
	toolTipMainText: i18n('Yeelight Control')
	toolTipSubText: {
		if (bulbOn) {
			return i18n('Middle-click to toggle the bulb off')
		} else {
			return i18n('Middle-click to toggle the bulb on')
		}
	}
	
	compactRepresentation: MouseArea {
		property bool wasExpanded: false
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton
		onClicked: mouse => {
			if (mouse.button == Qt.LeftButton) {
				main.expanded = !wasExpanded
			} else if (mouse.button == Qt.MiddleButton) {
				bulbOn = !bulbOn
			}
		}
		
		Kirigami.Icon {
			anchors.fill: parent
			source: plasmoid.icon
		}
	}
	
	fullRepresentation: PE.Representation {
		header: PE.PlasmoidHeading {
			RowLayout {
				anchors.fill: parent
				PC.TabBar {
					id: tabBar
					Layout.fillWidth: true
					Layout.fillHeight: true
					
					currentIndex: {
						switch (Plasmoid.configuration.currentTab) {
							case 'white':
								return whiteTab.PC.TabBar.index;
							case 'color':
								return colorTab.PC.TabBar.index;
						}
					}
					
					onCurrentIndexChanged: {
						switch (currentIndex) {
							case whiteTab.PC.TabBar.index:
								Plasmoid.configuration.currentTab = 'white';
								break;
							case colorTab.PC.TabBar.index:
								Plasmoid.configuration.currentTab = 'color';
								break;
						}
					}
					
					PC.TabButton {
						id: whiteTab
						text: i18n('White')
					}
					
					PC.TabButton {
						id: colorTab
						text: i18n('Color')
					}
				}
			}
		}
		
		contentItem: T.StackView {
			id: contentView
			
			PC.ScrollView {
				id: whiteView
				visible: tabBar.currentIndex == whiteTab.PC.TabBar.index
				ColumnLayout {
					Column {
						id: whiteBrightnessColumn
						RowLayout {
							PC.Label {
								id: whiteBrightnessLabel
								text: i18n('Brightness')
							}
							
							PC.Label {
								id: whiteBrightnessPercent
								horizontalAlignment: Text.AlignRight
								text: whiteBrightnessSlider.value + '%'
							}
						}
						PC.Slider {
							id: whiteBrightnessSlider
							from: 1
							to: 100
							stepSize: 1
							value: 100
							onValueChanged: {
								colorBrightnessSlider.value = whiteBrightnessSlider.value
							}
						}
					}
					
					Column {
						id: temperatureColumn
						RowLayout {
							PC.Label {
								id: temperatureLabel
								text: i18n('Temperature')
							}
							
							PC.Label {
								id: temperaturePercent
								horizontalAlignment: Text.AlignRight
								text: temperatureSlider.value + 'K'
							}
						}
						PC.Slider {
							id: temperatureSlider
							from: 1700
							to: 6500
							stepSize: 100
							value: 2700
						}
					}
				}
			}
			
			PC.ScrollView {
				id: colorView
				visible: tabBar.currentIndex == colorTab.PC.TabBar.index
				ColumnLayout {
					Column {
						id: colorBrightnessColumn
						RowLayout {
							PC.Label {
								id: colorBrightnessLabel
								text: i18n('Brightness')
							}
							
							PC.Label {
								id: colorBrightnessPercent
								horizontalAlignment: Text.AlignRight
								text: colorBrightnessSlider.value + '%'
							}
						}
						PC.Slider {
							id: colorBrightnessSlider
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
						RowLayout {
							PC.Label {
								id: redLabel
								text: i18n('Red')
							}
							
							PC.Label {
								id: redPercent
								horizontalAlignment: Text.AlignRight
								text: redSlider.value
							}
						}
						PC.Slider {
							id: redSlider
							from: 0
							to: 255
							stepSize: 1
							value: 255
						}
					}
					
					Column {
						id: greenColumn
						RowLayout {
							PC.Label {
								id: greenLabel
								text: i18n('Green')
							}
							
							PC.Label {
								id: greenPercent
								horizontalAlignment: Text.AlignRight
								text: greenSlider.value
							}
						}
						PC.Slider {
							id: greenSlider
							from: 0
							to: 255
							stepSize: 1
							value: 255
						}
					}
					
					Column {
						id: blueColumn
						RowLayout {
							PC.Label {
								id: blueLabel
								text: i18n('Blue')
							}
							
							PC.Label {
								id: bluePercent
								horizontalAlignment: Text.AlignRight
								text: blueSlider.value
							}
						}
						PC.Slider {
							id: blueSlider
							from: 0
							to: 255
							stepSize: 1
							value: 255
						}
					}
				}
			}
		}
		
		footer: PE.PlasmoidHeading {
			height: parent.header.height
			PC.CheckBox {
				id: onOffCheckBox
				anchors.leftMargin: Kirigami.Units.smallSpacing
				anchors.verticalCenter: parent.verticalCenter
				
				checked: true
				text: i18n('Turned On')
			}
		}
	}
}
