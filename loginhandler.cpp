#include "loginhandler.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QCryptographicHash>
#include <QNetworkReply>

LoginHandler::LoginHandler(QObject* parent) : QObject{parent}, networkManager(new QNetworkAccessManager(this)) {}

void LoginHandler::login(const QString& email, const QString& password) {
    emit loginProgress(true);

    if(!validateInput(email, password)) {
        emit loginProgress(false);
        emit loginError("Ivalid input data");
        return;
    }

    QJsonObject jsonPayload;
    jsonPayload["email"] = email;
    jsonPayload["password"] = hashPassword(password);

    QJsonDocument doc(jsonPayload);
    QByteArray data = doc.toJson();

    QNetworkRequest request;
    request.setUrl(QUrl("MAZARYN_API_ENDPOINT"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = networkManager->post(request, data);

    connect(reply, &QNetworkReply::finished, [=](){
        reply->deleteLater();
        emit loginProgress(false);
        if(reply->error() == QNetworkReply::NoError) {
            emit loginSuccess();
        } else {
            emit loginError(reply->errorString());
        }
    });
}

bool LoginHandler::validateInput(const QString &email,
                                 const QString &password)
{

    if (!email.contains("@") || !email.contains(".")) return false;

    // Password validation
    if (password.length() < 8) return false;

    return true;
}

QString LoginHandler::hashPassword(const QString &password)
{
    QByteArray hash = QCryptographicHash::hash(
        password.toUtf8(),
        QCryptographicHash::Sha256
    );
    return QString(hash.toHex());
}
