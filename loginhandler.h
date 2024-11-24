#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H
#include <QObject>
#include <QNetworkAccessManager>

class LoginHandler : public QObject {
    Q_OBJECT
public:
    explicit LoginHandler(QObject* parent = nullptr);

    Q_INVOKABLE void login(const QString& email, const QString& password);

signals:
    void loginSuccess();
    void loginError(const QString& error);
    void loginProgress(bool inProgress);
private:
    QNetworkAccessManager* networkManager;

    bool validateInput(const QString& email, const QString& password);
    QString hashPassword(const QString &password);
};

#endif // LOGINHANDLER_H
