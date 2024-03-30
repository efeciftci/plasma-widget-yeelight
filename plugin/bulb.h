#pragma once
#include <QDebug>
#include <QObject>
#include <QTcpSocket>

class Bulb: public QObject {
	Q_OBJECT
	Q_PROPERTY(QString ipAddress    READ ipAddress    WRITE setIpAddress    NOTIFY    ipAddressChanged)
	Q_PROPERTY(QString animType     READ animType     WRITE setAnimType     NOTIFY     animTypeChanged)
	Q_PROPERTY(int     animDuration READ animDuration WRITE setAnimDuration NOTIFY animDurationChanged)
	
public:
	explicit Bulb(QObject *parent = nullptr);
	~Bulb() override;
	
	QString ipAddress() const;
	void setIpAddress(const QString address);
	
	QString animType() const;
	void setAnimType(const QString animType);
	
	int animDuration() const;
	void setAnimDuration(const int animDuration);
	
	Q_INVOKABLE void execCmd(const QString method, const QString param);
	
Q_SIGNALS:
	void ipAddressChanged();
	void animTypeChanged();
	void animDurationChanged();
	
private:
	QString m_ipAddress;
	QString m_animType;
	int m_animDuration;
	QTcpSocket socket;
};
