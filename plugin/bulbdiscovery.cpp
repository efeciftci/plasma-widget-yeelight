#include "bulbdiscovery.h"

struct BulbInfo {
	QString addr, port, id;
	
	bool operator==(const BulbInfo &other) const { return id == other.id; }
};

inline size_t qHash(BulbInfo key, size_t seed) { return qHash(key.id, seed); }

BulbDiscovery::BulbDiscovery(QObject *parent): QObject(parent) {
}

BulbDiscovery::~BulbDiscovery() = default;

QString BulbDiscovery::search() {
	QUdpSocket udpSocket;
	QSet<BulbInfo> bulbs;
	QElapsedTimer timer;
	QRegularExpression idRegex(QString::fromUtf8("id: (.*)\r\n"));
	QRegularExpression locationRegex(QString::fromUtf8("Location: yeelight://(.*):(.*)\r\n"));
	QRegularExpressionMatch idMatch;
	QRegularExpressionMatch locationMatch;
	QJsonObject jsonObj;
	QJsonArray jsonArray;
	QJsonDocument jsonDoc;
	QByteArray datagram = 	"M-SEARCH * HTTP/1.1\r\n"
							"HOST: 239.255.255.250:1982\r\n"
							"MAN: \"ssdp:discover\"\r\n"
							"ST: wifi_bulb\r\n"
							"\r\n";
	QByteArray response;
	
	udpSocket.writeDatagram(datagram, QHostAddress(QString::fromUtf8("239.255.255.250")), 1982);
	
	timer.start();
	while (timer.elapsed() < 2000) {
		if (udpSocket.waitForReadyRead(1000)) {
			while (udpSocket.hasPendingDatagrams()) {
				response.resize(udpSocket.pendingDatagramSize());
				udpSocket.readDatagram(response.data(), response.size(), nullptr, nullptr);
				
				idMatch = idRegex.match(QString::fromUtf8(response));
				locationMatch = locationRegex.match(QString::fromUtf8(response));
				
				if (idMatch.hasMatch() && locationMatch.hasMatch()) {
					bulbs << BulbInfo({locationMatch.captured(1),
						locationMatch.captured(2), idMatch.captured(1)});
				}
			}
		}
	}
	
	for (const BulbInfo &bulb : bulbs) {
		jsonObj[QString::fromUtf8("addr")] = bulb.addr;
		jsonObj[QString::fromUtf8("id")] = bulb.id;
		jsonArray.append(jsonObj);
	}
	
	jsonDoc.setArray(jsonArray);
	return QString::fromUtf8(jsonDoc.toJson(QJsonDocument::Compact));
} 
