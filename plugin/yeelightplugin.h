#pragma once
#include <QQmlEngine>
#include <QQmlExtensionPlugin>
#include "bulb.h"
#include "bulbdiscovery.h"

class YeelightPlugin: public QQmlExtensionPlugin{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
	
public:
	void registerTypes(const char *uri) override;
};
