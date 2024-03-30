#include "bulb.h"

Bulb::Bulb(QObject *parent): QObject(parent), m_ipAddress(QString::fromUtf8("0.0.0.0")) {
	qDebug() << "Bulb() constructor";
}

Bulb::~Bulb() = default;

void Bulb::execCmd(const QString method, const QString param) {
	qDebug() << "ipAddress: " << m_ipAddress <<  ", method: " << method << ", param: " << param;
	// TODO: QTcpSocket read/write
}

QString Bulb::ipAddress() const {
	return m_ipAddress;
}

void Bulb::setIpAddress(QString address) {
	m_ipAddress = address;
	Q_EMIT ipAddressChanged();
}
