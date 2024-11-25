#include "resetpasswordhandler.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QRegularExpression>

ResetPasswordHandler::ResetPasswordHandler(QObject* parent)
    : QObject{parent}
    , networkManager(new QNetworkAccessManager(this))
    , timeoutTimer(new QTimer(this))
    , rateLimitTimer(new QTimer(this))
    , attemptCount(0)
{
    timeoutTimer->setSingleShot(true);
    connect(timeoutTimer, &QTimer::timeout, this, [this]() {
        emit resetPasswordProgress(false);
        emit resetPasswordError(tr("Request timed out. Please try again."));
    });

    rateLimitTimer->setInterval(ATTEMPT_WINDOW);
    connect(rateLimitTimer, &QTimer::timeout, this, &ResetPasswordHandler::resetAttemptCount);
}

void ResetPasswordHandler::requestPasswordReset(const QString& email)
{
    emit resetPasswordProgress(true);

    // Check rate limiting
    if (!checkRateLimit()) {
        emit resetPasswordProgress(false);
        emit resetPasswordError(tr("Too many attempts. Please try again later."));
        return;
    }

    if (!validateEmail(email)) {
        emit resetPasswordProgress(false);
        emit resetPasswordError(tr("Invalid email address"));
        return;
    }

    QJsonObject jsonPayload;
    jsonPayload["email"] = email;
    jsonPayload["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    QNetworkRequest request(QUrl("MAZARYN_API_ENDPOINT/reset-password"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Add security headers
    request.setRawHeader("X-CSRF-Token", "YOUR_CSRF_TOKEN");
    request.setRawHeader("X-Request-ID", QUuid::createUuid().toString().toUtf8());

    // Set timeout
    timeoutTimer->start(REQUEST_TIMEOUT);

    QNetworkReply* reply = networkManager->post(request, QJsonDocument(jsonPayload).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        timeoutTimer->stop();
        reply->deleteLater();
        emit resetPasswordProgress(false);

        if (reply->error() == QNetworkReply::NoError) {
            emit resetPasswordSuccess();
        } else {
            handleNetworkError(reply->error());
        }
    });
}

bool ResetPasswordHandler::validateEmail(const QString& email)
{
    // More comprehensive email validation
    QRegularExpression emailRegex(R"([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})");
    return emailRegex.match(email).hasMatch();
}

void ResetPasswordHandler::handleNetworkError(QNetworkReply::NetworkError error)
{
    QString errorMessage;
    switch(error) {
        case QNetworkReply::TimeoutError:
            errorMessage = tr("Connection timed out. Please try again.");
            break;
        case QNetworkReply::ConnectionRefusedError:
            errorMessage = tr("Connection refused. Please check your internet connection.");
            break;
        case QNetworkReply::ContentNotFoundError:
            errorMessage = tr("Email address not found.");
            break;
        case QNetworkReply::TooManyRedirectsError:
            errorMessage = tr("Service temporarily unavailable. Please try again later.");
            break;
        default:
            errorMessage = tr("An error occurred. Please try again later.");
    }
    emit resetPasswordError(errorMessage);
}

bool ResetPasswordHandler::checkRateLimit()
{
    if (attemptCount == 0) {
        rateLimitTimer->start();
    }

    attemptCount++;
    return attemptCount <= MAX_ATTEMPTS;
}

void ResetPasswordHandler::resetAttemptCount()
{
    attemptCount = 0;
    rateLimitTimer->stop();
}
