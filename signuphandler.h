#ifndef SIGNUPHANDLER_H
#define SIGNUPHANDLER_H
#include <QObject>
#include <QNetworkAccessManager>

class SignupHandler : public QObject {
    Q_OBJECT
public:
    explicit SignupHandler(QObject* parent = nullptr);

    Q_INVOKABLE void signup(const QString& username, const QString& email, const QString& password);

signals:
    void signupSuccess();
    void signupError(const QString& error);
    void signupProgress(bool inProgress);
private:
    QNetworkAccessManager* networkManager;

    bool validateInput(const QString& username, const QString& email, const QString& password);
    QString hashPassword(const QString &password);
};

#endif // SIGNUPHANDLER_H
