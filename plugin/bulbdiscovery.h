#pragma once 
#include <QObject>
#include <QCoreApplication>
#include <QRegularExpression>
#include <QUdpSocket>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

class BulbDiscovery: public QObject {
	Q_OBJECT

public:
	explicit BulbDiscovery(QObject *parent = nullptr);
	~BulbDiscovery() override;
	Q_INVOKABLE QString search();
};
