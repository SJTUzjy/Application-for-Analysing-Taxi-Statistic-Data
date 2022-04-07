#include "mythread.h"

Mythread::Mythread(QObject *parent) : QThread(parent)
{
    for(int i = 0; i < 20; i++)
        Loaded[i] = false;
}

void Mythread::run()
{
    db = QSqlDatabase::addDatabase("QSQLITE", "demand");
    db.setDatabaseName("demand.db");
    db.open();
    QSqlQuery query = QSqlQuery(db);
    QVariant order_id;int departure_time;int end_time;double origin_lng; double origin_lat;double dest_lng;double dest_lat;double fee;
    db.transaction();
    for(int i=startTime;i<=endTime;i++){//load all
        Loaded[i-20161101]=1;
        QString date=QString::number(i);
        query.exec("DROP TABLE if exists orders_" + QString::number(i));
        query.exec("CREATE TABLE orders_" + date + " ("
                       "order_id VARCHAR(40) PRIMARY KEY,"
                       "departure_time INTEGER NOT NULL, "
                       "end_time INTEGER NOT NULL, "
                       "orig_lng DOUBLE NOT NULL, "
                       "orig_lat DOUBLE NOT NULL, "
                       "dest_lng DOUBLE NOT NULL, "
                       "dest_lat DOUBLE NOT NULL,"
                       "fee DOUBLE NOT NULL)");
        for(int j = 1; j <= 100; j++) {
            query.exec("DROP TABLE if exists orders_" + QString::number(i) + "_orig_" + QString::number(j));
            query.exec("DROP TABLE if exists orders_" + QString::number(i) + "_dest_" + QString::number(j));
            query.exec("CREATE TABLE orders_" + date + "_orig_" + QString::number(j) + " ("
                           "order_id VARCHAR(40) PRIMARY KEY,"
                           "departure_time INTEGER NOT NULL, "
                           "end_time INTEGER NOT NULL, "
                           "orig_lng DOUBLE NOT NULL, "
                           "orig_lat DOUBLE NOT NULL, "
                           "dest_lng DOUBLE NOT NULL, "
                           "dest_lat DOUBLE NOT NULL,"
                           "fee DOUBLE NOT NULL)");
         query.exec("CREATE TABLE orders_" + date + "_dest_" + QString::number(j) + " ("
                           "order_id VARCHAR(40) PRIMARY KEY,"
                           "departure_time INTEGER NOT NULL, "
                           "end_time INTEGER NOT NULL, "
                           "orig_lng DOUBLE NOT NULL, "
                           "orig_lat DOUBLE NOT NULL, "
                           "dest_lng DOUBLE NOT NULL, "
                           "dest_lat DOUBLE NOT NULL,"
                           "fee DOUBLE NOT NULL)");
        }
                for(int j=0;j<5;j++)
                {
                    QString file1(Directoryname);
                    file1 += "\\order_";
                    file1+=QString::number(i);
                    file1+="_part";
                    file1+=QString::number(j);
                    file1+=".csv";
                    QFile file(file1);
                    file.open(QIODevice::ReadOnly);
                    QByteArray array=file.readLine();
                    while( !file.atEnd())
                    {

                        array = file.readLine();
                        QString s(array);

                        order_id=s.section(',',0,0); departure_time=s.section(',',1,1).toInt();end_time=s.section(',',2,2).toInt();
                        origin_lng=s.section(',',3,3).toDouble();origin_lat=s.section(',',4,4).toDouble();
                        dest_lng=s.section(',',5,5).toDouble();dest_lat=s.section(',',6,6).toDouble();fee=s.section(',',7,7).section('\xa',0,0).toDouble();


                        double x_1 = (origin_lat - 30.43414992) / 0.044966016;
                        double y_1 = (origin_lng - 103.8038618) / 0.05229722;
                        if(x_1 > 10) x_1 = 10;
                        if(y_1 > 10) y_1 = 10;
                        int x = trunc(x_1) * 10 + trunc(y_1) + 1;

                        query.prepare("INSERT INTO orders_" + date + "_orig_" + QString::number(x) + "(order_id,departure_time,end_time,orig_lng,orig_lat,dest_lng,dest_lat,fee)"
                                      " VALUES(:order_id,:departure_time,:end_time,:orig_lng,:orig_lat,:dest_lng,:dest_lat,:fee)");
                        query.bindValue(":order_id",order_id);
                        query.bindValue(":departure_time",departure_time);
                        query.bindValue(":end_time",end_time);
                        query.bindValue(":orig_lng",origin_lng);
                        query.bindValue(":orig_lat",origin_lat);
                        query.bindValue(":dest_lng",dest_lng);
                        query.bindValue(":dest_lat",dest_lat);
                        query.bindValue(":fee",fee);
                        query.exec();

                        double x_2 = (dest_lat - 30.43414992) / 0.044966016;
                        double y_2 = (dest_lng - 103.8038618) / 0.05229722;
                        if(x_1 > 10) x_2 = 10;
                        if(y_1 > 10) y_2 = 10;
                        x = trunc(x_2) * 10 + trunc(y_2) + 1;

                        query.prepare("INSERT INTO orders_" + date + "_dest_" + QString::number(x) + "(order_id,departure_time,end_time,orig_lng,orig_lat,dest_lng,dest_lat,fee)"
                                      " VALUES(:order_id,:departure_time,:end_time,:orig_lng,:orig_lat,:dest_lng,:dest_lat,:fee)");
                        query.bindValue(":order_id",order_id);
                        query.bindValue(":departure_time",departure_time);
                        query.bindValue(":end_time",end_time);
                        query.bindValue(":orig_lng",origin_lng);
                        query.bindValue(":orig_lat",origin_lat);
                        query.bindValue(":dest_lng",dest_lng);
                        query.bindValue(":dest_lat",dest_lat);
                        query.bindValue(":fee",fee);
                        query.exec();
                        query.prepare("INSERT INTO orders_" + date + "(order_id,departure_time,end_time,orig_lng,orig_lat,dest_lng,dest_lat,fee)"
                                      " VALUES(:order_id,:departure_time,:end_time,:orig_lng,:orig_lat,:dest_lng,:dest_lat,:fee)");
                        query.bindValue(":order_id",order_id);
                        query.bindValue(":departure_time",departure_time);
                        query.bindValue(":end_time",end_time);
                        query.bindValue(":orig_lng",origin_lng);
                        query.bindValue(":orig_lat",origin_lat);
                        query.bindValue(":dest_lng",dest_lng);
                        query.bindValue(":dest_lat",dest_lat);
                        query.bindValue(":fee",fee);
                        query.exec();

                        emit load_progressed();
                    }
                }
            }
  db.commit();
  emit isDone();
}
