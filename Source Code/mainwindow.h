#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtWidgets>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDateTime>
#include <QtCharts>
#include "mythread.h"
#include "vicewindow.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
private slots:
    void fileOpenActionSlot();
    void load_update();
    void load_start();
    void create_vice_ui();
    void appear();
    void draw(int, int, int, int, int);
    void drawHeat(int, int);
private:
    void createAction();
    void createMenu();
    void createContentMenu();

    void getsize(int);
    void selectDirectory();
    int cnt_dmd(int, int, int, int, int);
    int fee_dmd(int, int, int, int, int, int*);
    int tim_dmd(int, int, int, int, int, int*);
    void OrderChart(int, int, int, int);
    void TimeChart(int, int, int);
    void FeeChart(int, int, int);
    void LineChart(int, int, int);
    void Histogram(int, int, int);
    void PieChart(int, int);
    int get_level(int, int, int);
private:
    Mythread *thread1;

    QAction *fileOpenAction;
    QMenu *menu;
    Ui::MainWindow *ui;
    QVBoxLayout* layout;
    QString directory;
    QProgressBar *loadbar;
    QPushButton *ld, *cl;
    QSpinBox *mx, *mn;
    QFont *font1;

    int each_size[20] = {181172, 186261, 188746, 204182, 208406, 190342, 188196, 194113, 194415, 195280, 215099, 210450, 190606, 195559, 200896};
    QString level_color[10] = {"#00fafa", "#19e1e1", "#32c8c8", "#4bafaf", "#649696", "#966464", "#af4b4b", "#c83232", "#e11919", "#fa0000"};
    int sz;
    int v;

    const int ST = 1477929600;


    ViceWindow *vice_ui;

    int vice_mn, vice_mx;
};
#endif // MAINWINDOW_H
