#include "yeelightplugin.h"

void YeelightPlugin::registerTypes(const char *uri) {
	Q_ASSERT(QLatin1String(uri) == QLatin1String("com.efeciftci.yeelight"));
	qmlRegisterType<Bulb>(uri, 1, 0, "Bulb");
	qmlRegisterType<BulbDiscovery>(uri, 1, 0, "BulbDiscovery");
}
