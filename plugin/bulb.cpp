#include "bulb.h"

Bulb::Bulb(QObject *parent): QObject(parent), m_ipAddress(QString::fromUtf8("0.0.0.0")) {
}

Bulb::~Bulb() = default;

void Bulb::execCmd(const QString method, const QString param) {
	QString msg;
	socket.connectToHost(m_ipAddress, 55443);
	if (!socket.waitForConnected())
		return;
	
	if (method.compare(QString::fromUtf8("set_power")) == 0)
		msg = QString::fromUtf8("{\"id\":1, \"method\":\"%1\", \"params\":[\"%2\", \"smooth\", 200]}\r\n").arg(method).arg(param);
	else if (method.compare(QString::fromUtf8("set_bright")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"sudden\", 200]}\r\n").arg(method).arg(param);
	else if (method.compare(QString::fromUtf8("set_ct_abx")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"sudden\", 200]}\r\n").arg(method).arg(param);
	else if (method.compare(QString::fromUtf8("set_rgb")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"sudden\", 200]}\r\n").arg(method).arg(param);
	else
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"get_prop\",\"params\":[\"power\", \"bright\", \"ct\", \"rgb\", \"color_mode\"]}\r\n");
	
	socket.write(msg.toLocal8Bit());
	if (socket.waitForReadyRead())
		QByteArray reply = socket.readAll();
	
	socket.close();
}

QString Bulb::ipAddress() const {
	return m_ipAddress;
}

void Bulb::setIpAddress(const QString address) {
	m_ipAddress = address;
	Q_EMIT ipAddressChanged();
}
