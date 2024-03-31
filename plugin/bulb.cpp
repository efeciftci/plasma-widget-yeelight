#include "bulb.h"

Bulb::Bulb(QObject *parent): QObject(parent), m_ipAddress(QString::fromUtf8("0.0.0.0")), m_animType(QString::fromUtf8("smooth")), m_animDuration(500) {
}

Bulb::~Bulb() = default;

QString Bulb::ipAddress() const {
	return m_ipAddress;
}

void Bulb::setIpAddress(const QString address) {
	m_ipAddress = address;
	Q_EMIT ipAddressChanged();
}

QString Bulb::animType() const {
	return m_animType;
}

void Bulb::setAnimType(const QString animType) {
	m_animType = animType;
	Q_EMIT animTypeChanged();
}

int Bulb::animDuration() const {
	return m_animDuration;
}

void Bulb::setAnimDuration(const int animDuration) {
	m_animDuration = animDuration;
	Q_EMIT animDurationChanged();
}

void Bulb::execCmd(const QString method, const QString param) {
	QString msg;
	socket.connectToHost(m_ipAddress, 55443);
	if (!socket.waitForConnected())
		return;
	
	if (method.compare(QString::fromUtf8("set_power")) == 0)
		msg = QString::fromUtf8("{\"id\":1, \"method\":\"%1\", \"params\":[\"%2\", \"%3\", %4]}\r\n").arg(method).arg(param).arg(m_animType).arg(m_animDuration);
	else if (method.compare(QString::fromUtf8("set_bright")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"%3\", %4]}\r\n").arg(method).arg(param).arg(m_animType).arg(m_animDuration);
	else if (method.compare(QString::fromUtf8("set_ct_abx")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"%3\", %4]}\r\n").arg(method).arg(param).arg(m_animType).arg(m_animDuration);
	else if (method.compare(QString::fromUtf8("set_rgb")) == 0)
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"%1\",\"params\":[%2, \"%3\", %4]}\r\n").arg(method).arg(param).arg(m_animType).arg(m_animDuration);
	else
		msg = QString::fromUtf8("{\"id\":1,\"method\":\"get_prop\",\"params\":[\"power\", \"bright\", \"ct\", \"rgb\", \"color_mode\"]}\r\n");
	
	socket.write(msg.toLocal8Bit());
	if (socket.waitForReadyRead())
		QByteArray reply = socket.readAll();
	
	socket.close();
}

QString Bulb::fetchBulbState() {
	socket.connectToHost(m_ipAddress, 55443);
	if (socket.waitForConnected()) {
		QString msg = QString::fromUtf8("{\"id\":1,\"method\":\"get_prop\",\"params\":[\"power\",\"bright\",\"color_mode\",\"ct\",\"rgb\"]}\r\n");
		socket.write(msg.toLocal8Bit());
		if (socket.waitForReadyRead())
			return QString::fromUtf8(socket.readAll());
	}
	
	return QString::fromUtf8("{}");
}
