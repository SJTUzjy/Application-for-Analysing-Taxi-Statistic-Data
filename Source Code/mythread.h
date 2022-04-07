#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariant>
#include <QFile>
#include <cmath>
#include <QDebug>

class Mythread : public QThread
{
    Q_OBJECT
public:
    explicit Mythread(QObject *parent = nullptr);
private:
void run() override;
signals:
void load_progressed();
void isDone();
private:
QString Directoryname;

int startTime, endTime;
bool Loaded[20];
public:
QSqlDatabase db;

void setDirectory(QString x) {
    Directoryname = x;
}
void setTime(int x1, int x2) {
    startTime = x1;
    endTime = x2;
}
};

#endif // MYTHREAD_H

