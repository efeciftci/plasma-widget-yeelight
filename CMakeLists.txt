cmake_minimum_required(VERSION 3.16)
project(plasma-yeelight)
find_package(ECM 6.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Qml)
find_package(KF6 REQUIRED)
find_package(Plasma 6.0 REQUIRED)

plasma_install_package(package com.efeciftci.yeelight)

add_definitions(-DTRANSLATION_DOMAIN=\"libyeelight\")

set(yeelightplugin_SRCS
	plugin/bulb.cpp
	plugin/yeelightplugin.cpp
)

add_library(yeelightplugin SHARED ${yeelightplugin_SRCS})
target_link_libraries(yeelightplugin Qt::Core Qt::Qml)

install(FILES plugin/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/efeciftci/yeelight)
install(TARGETS yeelightplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/efeciftci/yeelight)

