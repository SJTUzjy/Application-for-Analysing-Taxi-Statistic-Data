#ifndef VICEWINDOW_H
#define VICEWINDOW_H

#include <QtWidgets>
#include <QLayout>
#include <QCloseEvent>
#include <QDebug>
#include <QtCharts>
#include <QQuickWidget>
#include <QQuickItem>
#include <QQmlEngine>
#include <QQmlContext>

class ViceWindow : public QWidget
{
    Q_OBJECT
public:
    explicit ViceWindow(QWidget *parent = nullptr);

signals:
    void isClosed();
    void click(int, int, int, int, int);
    void heatclick(int, int);

    void showRoute(double orig_lng, double orig_lat, double dest_lng, double dest_lat);
    void showPoint(int idx, double orig_lng, double orig_lat);
    void showRegion(int idx1, int idx2 , QString clr);
    void clearRegion();
    void removeRegion(int idx);
    void mouse_point(double, double);

protected:
     void closeEvent(QCloseEvent *event);

private slots:
     void setPieChart(bool);
     void send();
     void heatsend();
     void map_click(QVariant lat, QVariant lng);
     void map_click2(QVariant lat, QVariant lng);
     void area_switch(double, double);
     void area_changed();
     void show_points();
     void clear_custom(bool);
     void draw_route();

public:
     void toclearRegion() {emit clearRegion();}
     void toshowRegion(double idx1, double idx2, QString clr) {emit showRegion(idx1, idx2, clr);}

     int cnt;

     QFont *font1, *font2;
     QTabWidget *QTB;
     QWidget *mainw1, *mainw2;

 //Window1 Wdigets.............................................................................................

     bool is_chosen[101];

     QWidget* w1, *w2;
     QWidget* w10, *w11, *w12, *w22, *w21;
     QWidget* w121, *w120, *w221;

     QHBoxLayout *mainLayout, *mainLayout1, *layout22;
     QVBoxLayout *layout1, *layout2, *layout10, *layout11, *layout12,  *layout121, *layout221, *layout21;
     QGridLayout *layout120;
     QButtonGroup *QBG0, *QBG1, *QBG21, *QBG3, *QBG22;

     QRadioButton *c01, *c02, *c03;
     QRadioButton *c11, *c12, *c13;
     QRadioButton *c21, *c22, *c23, *c24;
     QRadioButton *c31, *c32;
     QSpinBox *s21[5];
     QSpinBox *startDay, *startHour, *endDay, *endHour;
     QDoubleSpinBox *timeStep;
     QPushButton *Draw, *HeatMap;

     QChart *chart;
     QChartView *cv;

 //Window2 Wdigets...........................................................................................

     QWidget *x1, *x2;

     QVBoxLayout *mainLayout2;
     QHBoxLayout *xlayout1, *xlayout2;

     QDoubleSpinBox *start_lat, *end_lat;
     QDoubleSpinBox *start_lng, *end_lng;
     QPushButton *Navigate;

     QQuickWidget *mapView, *mapView2;
     QObject *map_root, *map_root2;




};

#endif // VICEWINDOW_H
