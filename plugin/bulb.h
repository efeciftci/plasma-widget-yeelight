#pragma once
#include <QDebug>
#include <QObject>

class Bulb: public QObject {
	Q_OBJECT
	Q_PROPERTY(QString ipAddress READ ipAddress WRITE setIpAddress NOTIFY ipAddressChanged)
	
public:
	explicit Bulb(QObject *parent = nullptr);
	~Bulb() override;
	
	QString ipAddress() const;
	void setIpAddress(QString address);
	
	Q_INVOKABLE void execCmd(const QString method, const QString param);
	
Q_SIGNALS:
	void ipAddressChanged();
	
private:
	QString m_ipAddress;
};
