#ifndef RESETPASSWORDHANDLER_H
#define RESETPASSWORDHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QTimer>
#include <QString>
#include <qnetworkreply.h>

class ResetPasswordHandler : public QObject
{
    Q_OBJECT
public:
    explicit ResetPasswordHandler(QObject* parent = nullptr);
    Q_INVOKABLE void requestPasswordReset(const QString& email);

signals:
    void resetPasswordProgress(bool inProgress);
    void resetPasswordSuccess();
    void resetPasswordError(const QString& error);

private:
    static constexpr int REQUEST_TIMEOUT = 30000; // 30 seconds
    static constexpr int MAX_ATTEMPTS = 3; // Maximum attempts within time window
    static constexpr int ATTEMPT_WINDOW = 3600000; // 1 hour in milliseconds

    QNetworkAccessManager* networkManager;
    QTimer* timeoutTimer;
    QTimer* rateLimitTimer;
    int attemptCount;

    bool validateEmail(const QString& email);
    void handleNetworkError(QNetworkReply::NetworkError error);
    bool checkRateLimit();
    void resetAttemptCount();
};

#endif // RESETPASSWORDHANDLER_H
