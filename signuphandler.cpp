#include "signuphandler.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QCryptographicHash>
#include <QNetworkReply>

SignupHandler::SignupHandler(QObject* parent) : QObject{parent}, networkManager(new QNetworkAccessManager(this)) {}

void SignupHandler::signup(const QString& username, const QString& email, const QString& password) {
    emit signupProgress(true);

    if(!validateInput(username, email, password)) {
        emit signupProgress(false);
        emit signupError("Ivalid input data");
        return;
    }

    QJsonObject jsonPayload;
    jsonPayload["username"] = username;
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
        emit signupProgress(false);
        if(reply->error() == QNetworkReply::NoError) {
            emit signupSuccess();
        } else {
            emit signupError(reply->errorString());
        }
    });
}

bool SignupHandler::validateInput(const QString &username,
                                const QString &email,
                                const QString &password)
{
    if (username.length() < 3) return false;

    if (!email.contains("@") || !email.contains(".")) return false;

    // Password validation
    if (password.length() < 8) return false;

    return true;
}

QString SignupHandler::hashPassword(const QString &password)
{
    QByteArray hash = QCryptographicHash::hash(
        password.toUtf8(),
        QCryptographicHash::Sha256
    );
    return QString(hash.toHex());
}
