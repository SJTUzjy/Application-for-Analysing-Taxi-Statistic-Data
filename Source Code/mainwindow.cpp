#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "QMenu"
#include "QMenuBar"
#include "QAction"
#include "QMessageBox"
#include "QFileDialog"
#include "QDebug"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this); 
    vice_ui = new ViceWindow();
    QWidget *w1, *w2, *w3;
    QLayout *layout1, *layout2, *layout3;
    w1 = new QWidget(centralWidget() );
    w2 = new QWidget(centralWidget());
    w3 = new QWidget(centralWidget());
    layout1 = new QHBoxLayout(w1);
    layout2 = new QHBoxLayout(w2);
    layout3 = new QHBoxLayout(w3);
    mn = new QSpinBox(w1);
    mx = new QSpinBox(w1);
    mn -> setMinimum(20161101);
    mn -> setMaximum(20161115);
    mx -> setMinimum(20161101);
    mx -> setMaximum(20161115);
    font1 = new QFont();
    font1 -> setPointSize(10);
    auto label1 = new QLabel("Start Time", w1);
    auto label2 = new QLabel("End Time", w1);
    label1 -> setFont(*font1);
    label2 -> setFont(*font1);
    layout1 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    layout1 -> addWidget(label1);
    layout1 -> addWidget(mn);
    layout1 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    layout1 -> addWidget(label2);
    layout1 -> addWidget(mx);
    layout1 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    ld = new QPushButton("Load", w2);
    cl = new QPushButton("Cancel", w2);
    ld -> setFont(*font1);
    cl -> setFont(*font1);
    layout2 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    layout2 -> addWidget(ld);
    layout2 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    layout2 -> addWidget(cl);
    layout2 -> addItem(new QSpacerItem(0, 0, QSizePolicy::Expanding));
    thread1 = new Mythread();

    connect(thread1, SIGNAL(load_progressed()), this, SLOT(load_update()));
    connect(ld, SIGNAL(clicked()), this, SLOT(load_start()));
    connect(cl, SIGNAL(clicked()), thread1, SLOT(terminate()));
    connect(thread1, SIGNAL(isDone()), this, SLOT(create_vice_ui()));
    connect(vice_ui, SIGNAL(isClosed()), this, SLOT(appear()));
    connect(vice_ui, SIGNAL(click(int, int, int, int, int)), this, SLOT(draw(int, int, int, int, int)));
    connect(vice_ui, SIGNAL(heatclick(int, int)), this, SLOT(drawHeat(int, int)));

    this -> setWindowTitle("Loading Window");
    this -> centralWidget() -> setEnabled(false);
    createAction();
    createMenu();
    createContentMenu();
    layout = new QVBoxLayout();
    loadbar = new QProgressBar();
    layout -> addWidget(w1);
    layout -> addStretch();
    layout -> addWidget(w2);
    layout3 -> addItem(new QSpacerItem(30, 0, QSizePolicy::Fixed));
    layout3 -> addWidget(loadbar);
    w3 -> setLayout(layout3);
    layout -> addWidget(w3);
    this -> centralWidget() -> setLayout(layout);
}

void MainWindow::createAction()
{
    fileOpenAction = new QAction(tr("Open a Directory"),this);
    fileOpenAction->setShortcut(tr("Ctrl+O"));
    fileOpenAction->setStatusTip("Open a Directory");
    connect(fileOpenAction,SIGNAL(triggered()),this,SLOT(fileOpenActionSlot()));
}
void MainWindow::createMenu()
{
    menu = this->menuBar()->addMenu(tr("File"));
    menu->addAction(fileOpenAction);
}

void MainWindow::createContentMenu()
{
    this->addAction(fileOpenAction);
    this->setContextMenuPolicy(Qt::ActionsContextMenu);
}

void MainWindow::fileOpenActionSlot()
{
   selectDirectory();
}

void MainWindow::load_start() {
    int t1 = mn -> value();
    int t2 = mx -> value();
    if(t2 < t1) {
        QMessageBox::information(NULL, "Error", "The start time should be earlier than the end time");
        return;
    }
    thread1 -> setTime(t1, t2);
    vice_mn = t1;
    vice_mx = t2;
    int sum = 0;
    for(int i = t1 - 20161101; i <= t2 - 20161101; i++)
        sum += each_size[i];
    getsize(sum);
    thread1 -> start();
}
void MainWindow::selectDirectory()
{
    directory = QFileDialog::getExistingDirectory(this, tr("Choose Directory"),  QDir::currentPath(), QFileDialog::ShowDirsOnly);
    if(!directory.isEmpty()) {
        this -> centralWidget() -> setEnabled(true);
        thread1 -> setDirectory(directory);
    }
}

void MainWindow::getsize(int x) {
    sz = x;
    v = 0;
    loadbar -> setRange(0, sz);
}

void MainWindow::load_update() {
    loadbar -> setValue(++v);
}

void MainWindow::appear() {
    this -> setHidden(0);
}

void MainWindow::create_vice_ui() {
    this -> setHidden(1);
    vice_ui -> show();
}

int MainWindow::cnt_dmd(int x, int time_kind, int area_kind, int mntime, int mxtime) { //区域编号(x = 0~100, 0表示全域)， 出发或到达时间(time_kind = 1 or 2),
    QString tm = time_kind == 1? "departure_time " : "end_time ";
    QSqlQuery query = QSqlQuery(thread1 -> db);
    int cnt = 0;                                                                        //下述为优化，为避免每次都查询所有loaded table
    int tmn = (mntime - ST) / 86400;                                                    //计算时间下限属于哪个表
    int tmx = (mxtime - ST) / 86400;                                                    //计算时间上限属于哪个表
    if(tmx > 14) tmx = 14;
    for(int i = tmn + 20161101; i <= tmx + 20161101; i++) {
        if(!x)  {
                query.exec("select COUNT(*) from orders_" + QString::number(i)  + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime));
                while(query.next()) cnt+=query.value(0).toInt();
        }
         else {
            query.exec("select COUNT(*) from orders_" + QString::number(i) + (area_kind == 1? "_orig_" : "_dest_") + QString::number(x) + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime));
            while(query.next()) cnt+=query.value(0).toInt();
     }
    }
    return cnt;
}

int MainWindow::fee_dmd(int x, int time_kind, int area_kind, int mntime, int mxtime, int* lst) {    //函数参数基本同上，新增一个数组接口，表示每段价格区间内的订单数，函数返回值为订单总数 * (104.3265902 - 103.8038618) / 10;
    QString tm = time_kind == 1? "departure_time " : "end_time ";
    QSqlQuery query = QSqlQuery(thread1 -> db);
    int tmn = (mntime - ST) / 86400;
    int tmx = (mxtime - ST) / 86400;
    if(tmx > 14) tmx = 14;
    for(int j = 0; j < 20; j++) {
        lst[j] = 0;
       for(int i = tmn + 20161101; i <= tmx + 20161101; i++) {
         if(!x) {
                query.exec("select COUNT(*) from orders_" + QString::number(i) + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime) + " AND fee > " + QString::number(j) + " AND fee < " + QString::number(j + 1));
                while(query.next()) lst[j] += query.value(0).toInt();
         }
            else {query.exec("select COUNT(*) from orders_" + QString::number(i) + (area_kind == 1? "_orig_" : "_dest_") + QString::number(x) + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime) + " AND fee > " + QString::number(j) + " AND fee < " + QString::number(j + 1));
            while(query.next()) lst[j] += query.value(0).toInt();
         }
        }
    }
    return cnt_dmd(x, time_kind, area_kind, mntime, mxtime);
}

int MainWindow::tim_dmd(int x, int time_kind, int area_kind, int mntime, int mxtime, int* lst) { //函数参数同上，只是把查询的目标从价格改为旅程时间，同时，时间范围为0~80分钟，每4分钟为一统计点
    QString tm = time_kind == 1? "departure_time " : "end_time ";
    QSqlQuery query = QSqlQuery(thread1 -> db);
    int tmn = (mntime - ST) / 86400;
    int tmx = (mxtime - ST) / 86400;
    if(tmx > 14) tmx = 14;
    for(int j = 0; j < 20; j++) {
        lst[j] = 0;
       for(int i = tmn + 20161101; i <= tmx + 20161101; i++) {
           if(!x) {
              query.exec("select COUNT(*) from orders_" + QString::number(i) + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime) + " AND end_time - departure_time > " + QString::number(j * 240) + " AND end_time - departure_time < " + QString::number((j + 1) * 240));
              while(query.next()) lst[j] += query.value(0).toInt();
           }
              else {query.exec("select COUNT(*) from orders_" + QString::number(i) + (area_kind == 1? "_orig_" : "_dest_") + QString::number(x) + " WHERE " + tm + "> " + QString::number(mntime) + " AND " + tm + "< " + QString::number(mxtime) + " AND end_time - departure_time > " + QString::number(j * 240) + " AND end_time - departure_time < " + QString::number((j + 1) * 240));
              while(query.next()) lst[j] += query.value(0).toInt();
           }
        }
    }
    return cnt_dmd(x, time_kind, area_kind, mntime, mxtime);
}

void MainWindow::draw(int DataOption, int ChartPattern, int AllArea, int DeArea, int DeTime) { //按下绘画按钮后的SLOT
    delete this -> vice_ui -> chart;
    delete this -> vice_ui -> cv;
    this -> vice_ui -> chart = new QChart();
    this -> vice_ui -> cv = new QChartView(this -> vice_ui -> chart);
    this -> vice_ui -> layout21 -> addWidget(this -> vice_ui -> cv);
    if(this -> vice_ui -> startDay -> value() < vice_mn || this -> vice_ui -> endDay -> value() > vice_mx) {
        QMessageBox::information(NULL, "Error", "The time range you choose isn't included in the loaded range totally, please choose again");
        return;
    }
    switch (DataOption) {                                                           //选择需要分析的数据，字面意思，下同，只是选择函数
    case 1 : OrderChart(ChartPattern, AllArea, DeArea, DeTime); break;
    case 2 : TimeChart(AllArea, DeArea, DeTime); break;
    case 3 : FeeChart(AllArea, DeArea, DeTime);
    }
}

void MainWindow::OrderChart(int ChartPattern, int AllArea, int DeArea, int DeTime) {
    switch (ChartPattern) {
    case 1 : LineChart(AllArea, DeArea, DeTime); break;
    case 2 : Histogram(AllArea, DeArea, DeTime); break;
    case 3 : PieChart(DeArea, DeTime);
    }
}

void MainWindow::LineChart(int AllArea, int DeArea, int DeTime) {                   //曲线图函数，后同，不做过多解释
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;       //起始时间的时间戳
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;             //终止时间的时间戳
    int timestep = static_cast<int>(this -> vice_ui -> timeStep -> value() * 3600); //将步长转化为秒数
    int point_num = (end_time - start_time) / timestep;                             //总共有多少步
    if(point_num <= 1) {                                                            //若步数太少或者起始终止时间不对劲，返回
        QMessageBox::information(NULL, "Error", "The time range you choose is too small or the time step you choose is too large, please choose again");
        return;
    }
    int maxn = 0;
    if(AllArea == 1) {                                                              //如果是全域查询
        auto QLS = new QSplineSeries();
        this -> vice_ui -> chart -> setTitle("Line Chart of Number of Orders");
        auto axisX = new QDateTimeAxis();
        auto axisY = new QValueAxis();
        QLS -> setName(QString("All Area"));
        this -> vice_ui -> chart -> addSeries(QLS);
        for(int i = 0; (i + 1) * timestep <= end_time - start_time; i++) {
            int x = cnt_dmd(0, DeTime, DeArea, start_time + i * timestep, start_time + (i + 1) * timestep);
            QLS -> append(QDateTime::fromTime_t(start_time + i * timestep).toMSecsSinceEpoch(), x);
            maxn = (maxn < x ? x : maxn);
        }
        maxn = maxn * 6 / 5;                                                        //纵轴最大值
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY, Qt::AlignLeft);
        axisX -> setRange(QDateTime::fromTime_t(start_time), QDateTime::fromTime_t(start_time + (point_num - 1) * timestep));
        axisY -> setRange(0, maxn);
        axisY -> setLabelFormat("%d");
        axisX -> setTitleText("Time/h");
        axisY -> setTitleText("Number of Orders");
        QLS -> attachAxis(axisX);
        QLS -> attachAxis(axisY);
    } else {                                                                    //如果是分区域查询
        this -> vice_ui -> chart -> setTitle("Line Chart of Number of Orders");
        auto axisX = new QDateTimeAxis();
        auto axisY = new QValueAxis();
        axisY -> setLabelFormat("%d");
        axisX -> setTitleText("Time/h");
        axisY -> setTitleText("Number of Orders");
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY, Qt::AlignLeft);
        for(int i = 0; i < 5; i++) {
            if(this -> vice_ui -> s21[i] -> value() == 0) continue;
            auto QLS = new QSplineSeries();
            QLS -> setName(QString("Area " + QString::number(this -> vice_ui -> s21[i] -> value())));
            this -> vice_ui -> chart -> addSeries(QLS);
            for(int j = 0; (j + 1) * timestep <= end_time - start_time; j++) {
                int x = cnt_dmd(this -> vice_ui -> s21[i] -> value(), DeTime, DeArea, start_time + j * timestep, start_time + (j + 1) * timestep);
                QLS -> append(QDateTime::fromTime_t(start_time + j * timestep).toMSecsSinceEpoch(), x);
                maxn = (maxn < x ? x : maxn);
            }
            QLS -> attachAxis(axisX);
            QLS -> attachAxis(axisY);
        }
        maxn = maxn * 6 / 5;
        axisX -> setRange(QDateTime::fromTime_t(start_time), QDateTime::fromTime_t(start_time + (point_num - 1) * timestep));
        axisY -> setRange(0, maxn);
    }
}



void MainWindow::Histogram(int AllArea, int DeArea, int DeTime) {       //内置临时变量和参数基本同上
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;
    int timestep = static_cast<int>(this -> vice_ui -> timeStep -> value() * 3600);
    int point_num = (end_time - start_time) / timestep;
    if(point_num <= 1) {
        QMessageBox::information(NULL, "Error", "The time range you choose is too small or the time step you choose is too large, please choose again");
        return;
    } else if(point_num >= 10) {                                        //如果点数太多，推荐用户采用曲线图
        QMessageBox::information(NULL, "Warning", "The time range you choose is too large or the time step you choose is too small, we recommend you to use line chart");
    }
    int maxn = 0;
    if(AllArea == 1) {
        auto QBSe = new QBarSeries();
        auto QBS = new QBarSet("All Area");
        this -> vice_ui -> chart -> setTitle("Histogram of Number of Orders");
        auto axisX = new QBarCategoryAxis();
        auto axisY = new QValueAxis();
        for(int i = 0; (i + 1) * timestep <= end_time - start_time; i++) {
            int x = cnt_dmd(0, DeTime, DeArea, start_time + i * timestep, start_time + (i + 1) * timestep);
            axisX -> append(QDateTime::fromTime_t(start_time + i * timestep).toString());
            *QBS << x;
            maxn = (maxn < x ? x : maxn);
        }
        QBSe -> append(QBS);
        maxn = maxn * 6 / 5;
        axisY -> setRange(0, maxn);
        axisY -> setLabelFormat("%d");
        axisX -> setTitleText("Time/h");
        axisY -> setTitleText("Number of Orders");
        this -> vice_ui -> chart -> addSeries(QBSe);
        this -> vice_ui -> chart -> setAxisX(axisX, QBSe);
        this -> vice_ui -> chart -> setAxisY(axisY, QBSe);
    } else {
        auto QBSe = new QBarSeries();
        this -> vice_ui -> chart -> setTitle("Histogram of Number of Orders");
        auto axisX = new QBarCategoryAxis();
        auto axisY = new QValueAxis();
        for(int i = 0; (i + 1) * timestep <= end_time - start_time; i++) axisX -> append(QDateTime::fromTime_t(start_time + i * timestep).toString());
        for(int i = 0; i < 5; i++) {
            if(this -> vice_ui -> s21[i] -> value() == 0) continue;
            auto QBS = new QBarSet("Area " + QString::number(this -> vice_ui -> s21[i] -> value()));
            for(int j = 0; (j + 1) * timestep <= end_time - start_time; j++) {
                int x = cnt_dmd(this -> vice_ui -> s21[i] -> value(), DeTime, DeArea, start_time + j * timestep, start_time + (j + 1) * timestep);
                *QBS << x;
                maxn = (maxn < x ? x : maxn);
            }
            QBSe -> append(QBS);
        }
        maxn = maxn * 6 / 5;
        axisY -> setRange(0, maxn);
        axisY -> setLabelFormat("%d");
        axisX -> setTitleText("Time/h");
        axisY -> setTitleText("Number of Orders");
        this -> vice_ui -> chart -> addSeries(QBSe);
        this -> vice_ui -> chart -> setAxisX(axisX, QBSe);
        this -> vice_ui -> chart -> setAxisY(axisY, QBSe);
    }

}

void MainWindow::PieChart(int DeArea, int DeTime) {
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;
    auto QPSe = new QPieSeries();
    this -> vice_ui -> chart -> setTitle("Pie Chart of Number of Orders");
    int pie[5];
    int sum = 0;
    for(int i = 0; i < 5; i++) {
        if(this -> vice_ui -> s21[i] -> value() == 0) {pie[i] = -1; continue;}
        pie[i] = cnt_dmd(this -> vice_ui -> s21[i] -> value(), DeTime, DeArea, start_time, end_time);
        sum += pie[i];
    }
    double per[5];
    if(!sum) {
        QMessageBox::information(NULL, "Error", "No statistic data related");
        return;
    }
    for(int i = 0; i < 5; i++) {
        if(pie[i] < 0) continue;
        per[i] = double(pie[i]) / sum * 100;
        QPSe -> append("Area " + QString::number(this -> vice_ui -> s21[i] -> value()) + " : " + QString::number(per[i]) + "%, " + QString::number(pie[i]), pie[i]);
    }

    QPSe -> setLabelsVisible(true);
    QPSe -> setUseOpenGL(true);
    this -> vice_ui -> chart -> legend() -> setVisible(true);
    this -> vice_ui -> chart -> legend() -> setAlignment(Qt::AlignBottom);
    this -> vice_ui -> chart -> legend() -> setBackgroundVisible(true);
    this -> vice_ui -> chart -> legend() -> setAutoFillBackground(true);
    this -> vice_ui -> chart -> legend() -> setMaximumHeight(50);

    this -> vice_ui -> chart -> addSeries(QPSe);
}

void MainWindow::TimeChart(int AllArea, int DeArea, int DeTime) {
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;
    if(end_time - start_time <= 1) {
        QMessageBox::information(NULL, "Error", "The time you set is incorrect, please choose again");
        return;
    }
    if(AllArea == 1) {
        int tim_lst[21];
        int tim_sum[21];
        int sum = tim_dmd(0, DeTime, DeArea, start_time, end_time, tim_lst);
        tim_sum[0] = tim_lst[0];
        int maxn = 0;
        for(int i = 1; i < 20; i++) {
            tim_sum[i] = tim_sum[i - 1] + tim_lst[i];
            maxn = maxn < tim_lst[i] ? tim_lst[i] : maxn;
        }
        auto QLS1 = new QSplineSeries();
        auto QLS2 = new QSplineSeries();
        this -> vice_ui -> chart -> setTitle("Traval Time Disribution Chart");
        auto axisX = new QValueAxis();
        auto axisY1 = new QValueAxis();
        auto axisY2 = new QValueAxis();
        QLS1 -> append(0, 0);
        QLS2 -> append(0, 0);
        for(int i = 0; i < 20; i++) {
            QLS1 -> append((i + 1) * 4, (double) tim_lst[i] / sum / 4);
            QLS2 -> append((i + 1) * 4, (double) tim_sum[i] / sum);
        }
        QLS1 -> setName(QString("All Area Density Function"));
        QLS2 -> setName(QString("All Area Distribution Function"));
        this -> vice_ui -> chart -> addSeries(QLS1);
        this -> vice_ui -> chart -> addSeries(QLS2);
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY1, Qt::AlignLeft);
        this -> vice_ui -> chart -> addAxis(axisY2, Qt::AlignRight);
        axisX -> setRange(0, 80);
        axisY1 -> setRange(0, ((double) maxn) * 0.3 / sum);
        axisY2 -> setRange(0, 1);
        axisX -> setLabelFormat("%d");
        axisY1 -> setLabelFormat("%f");
        axisY2 -> setLabelFormat("%f");
        axisX -> setTitleText("Trave Time/min");
        axisY1 -> setTitleText("Density");
        axisY2 -> setTitleText("Prosibility");
        QLS1 -> attachAxis(axisX);
        QLS1 -> attachAxis(axisY1);
        QLS2 -> attachAxis(axisX);
        QLS2 -> attachAxis(axisY2);
    } else {
        this -> vice_ui -> chart -> setTitle("Traval Time Disribution Chart");
        auto axisX = new QValueAxis();
        auto axisY1 = new QValueAxis();
        auto axisY2 = new QValueAxis();
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY1, Qt::AlignLeft);
        this -> vice_ui -> chart -> addAxis(axisY2, Qt::AlignRight);
        double maxn = 0;
        for(int j = 0; j < 5; j++) {
            int x = this -> vice_ui -> s21[j] -> value();
            if(!x) continue;
            int tim_lst[21];
            int tim_sum[21];
            int sum = fee_dmd(x, DeTime, DeArea, start_time, end_time, tim_lst);
            tim_sum[0] = tim_lst[0];
            for(int i = 1; i < 20; i++) {
                tim_sum[i] = tim_sum[i - 1] + tim_lst[i];
                double p = ((double) tim_lst[i]) / sum / 4;
                maxn = maxn < p ? p : maxn;
            }
            auto QLS1 = new QSplineSeries();
            auto QLS2 = new QSplineSeries();
            for(int i = 0; i < 20; i++) {
                QLS1 -> append((i + 1) * 4, (double) tim_lst[i] / sum / 4);
                QLS2 -> append((i + 1) * 4, (double) tim_sum[i] / sum);
            }
            QLS1 -> setName(QString("Area" + QString::number(x) + " Density Function"));
            QLS2 -> setName(QString("Area" + QString::number(x) + " Distribution Function"));
            this -> vice_ui -> chart -> addSeries(QLS1);
            this -> vice_ui -> chart -> addSeries(QLS2);
            QLS1 -> attachAxis(axisX);
            QLS1 -> attachAxis(axisY1);
            QLS2 -> attachAxis(axisX);
            QLS2 -> attachAxis(axisY2);
        }
        axisX -> setRange(0, 80);
        axisY1 -> setRange(0, maxn * 1.2);
        axisY2 -> setRange(0, 1);
        axisX -> setLabelFormat("%d");
        axisY1 -> setLabelFormat("%f");
        axisY2 -> setLabelFormat("%f");
        axisX -> setTitleText("Trave Time/min");
        axisY1 -> setTitleText("Density");
        axisY2 -> setTitleText("Prosibility");
    }
}

void MainWindow::FeeChart(int AllArea, int DeArea, int DeTime) {
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;
    if(end_time - start_time <= 1) {
        QMessageBox::information(NULL, "Error", "The time you set is incorrect, please choose again");
        return;
    }
    if(AllArea == 1) {
        int fee_lst[21];
        int fee_sum[21];
        int sum = fee_dmd(0, DeTime, DeArea, start_time, end_time, fee_lst);
        fee_sum[0] = fee_lst[0];
        int maxn = 0;
        for(int i = 1; i < 20; i++) {
            fee_sum[i] = fee_sum[i - 1] + fee_lst[i];
            maxn = maxn < fee_lst[i] ? fee_lst[i] : maxn;
        }
        auto QLS1 = new QSplineSeries();
        auto QLS2 = new QSplineSeries();
        this -> vice_ui -> chart -> setTitle("Fee Disribution Chart");
        auto axisX = new QValueAxis();
        auto axisY1 = new QValueAxis();
        auto axisY2 = new QValueAxis();
        for(int i = 0; i < 20; i++) {
            QLS1 -> append(i + 1, (double) fee_lst[i] / sum);
            QLS2 -> append(i + 1, (double) fee_sum[i] / sum);
        }
        QLS1 -> setName(QString("All Area Density Function"));
        QLS2 -> setName(QString("All Area Distribution Function"));
        this -> vice_ui -> chart -> addSeries(QLS1);
        this -> vice_ui -> chart -> addSeries(QLS2);
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY1, Qt::AlignLeft);
        this -> vice_ui -> chart -> addAxis(axisY2, Qt::AlignRight);
        axisX -> setRange(1, 20);
        axisY1 -> setRange(0, ((double) maxn) * 1.2 / sum);
        axisY2 -> setRange(0, 1);
        axisX -> setLabelFormat("%d");
        axisY1 -> setLabelFormat("%f");
        axisY2 -> setLabelFormat("%f");
        axisX -> setTitleText("Fee/RMB");
        axisY1 -> setTitleText("Density");
        axisY2 -> setTitleText("Prosibility");
        QLS1 -> attachAxis(axisX);
        QLS1 -> attachAxis(axisY1);
        QLS2 -> attachAxis(axisX);
        QLS2 -> attachAxis(axisY2);
    } else {
        this -> vice_ui -> chart -> setTitle("Fee Disribution Chart");
        auto axisX = new QValueAxis();
        auto axisY1 = new QValueAxis();
        auto axisY2 = new QValueAxis();
        this -> vice_ui -> chart -> addAxis(axisX, Qt::AlignBottom);
        this -> vice_ui -> chart -> addAxis(axisY1, Qt::AlignLeft);
        this -> vice_ui -> chart -> addAxis(axisY2, Qt::AlignRight);
        double maxn = 0;
        for(int j = 0; j < 5; j++) {
            int x = this -> vice_ui -> s21[j] -> value();
            if(!x) continue;
            int fee_lst[21];
            int fee_sum[21];
            int sum = fee_dmd(x, DeTime, DeArea, start_time, end_time, fee_lst);
            fee_sum[0] = fee_lst[0];
            for(int i = 1; i < 20; i++) {
                fee_sum[i] = fee_sum[i - 1] + fee_lst[i];
                double p = ((double) fee_lst[i]) / sum;
                maxn = maxn < p ? p : maxn;
            }
            auto QLS1 = new QSplineSeries();
            auto QLS2 = new QSplineSeries();
            for(int i = 0; i < 20; i++) {
                QLS1 -> append(i + 1, (double) fee_lst[i] / sum);
                QLS2 -> append(i + 1, (double) fee_sum[i] / sum);
            }
            QLS1 -> setName(QString("Area" + QString::number(x) + " Density Function"));
            QLS2 -> setName(QString("Area" + QString::number(x) + " Distribution Function"));
            this -> vice_ui -> chart -> addSeries(QLS1);
            this -> vice_ui -> chart -> addSeries(QLS2);
            QLS1 -> attachAxis(axisX);
            QLS1 -> attachAxis(axisY1);
            QLS2 -> attachAxis(axisX);
            QLS2 -> attachAxis(axisY2);
        }
        axisX -> setRange(1, 20);
        axisY1 -> setRange(0, maxn * 1.2);
        axisY2 -> setRange(0, 1);
        axisX -> setLabelFormat("%d");
        axisY1 -> setLabelFormat("%f");
        axisY2 -> setLabelFormat("%f");
        axisX -> setTitleText("Fee/RMB");
        axisY1 -> setTitleText("Density");
        axisY2 -> setTitleText("Prosibility");
    }
}


void MainWindow::drawHeat(int DeArea, int DeTime) {
    int start_day = this -> vice_ui -> startDay -> value();
    int start_hour = this -> vice_ui -> startHour -> value();
    int end_day = this -> vice_ui -> endDay -> value();
    int end_hour = this -> vice_ui -> endHour -> value();
    if(start_day < vice_mn || end_day > vice_mx) {
        QMessageBox::information(NULL, "Error", "The time range you choose isn't included in the loaded range totally, please choose again");
        return;
    }
    int start_time = ST + (start_day - 20161101) * 86400 + start_hour * 3600;
    int end_time = ST + (end_day - 20161101) * 86400 + end_hour * 3600;
    int order_num[101];
    int maxn = 0, minn = 2147483647;
    for(int i = 1; i <= 100; i++) {
        order_num[i] = cnt_dmd(i, DeTime, DeArea, start_time, end_time);
        maxn = maxn < order_num[i] ? order_num[i] : maxn;
        minn = minn > order_num[i] ? order_num[i] : minn;
    }
    vice_ui -> toclearRegion();
    for(int i = 1; i <= 100; i++) {
        int level = get_level(maxn, minn, order_num[i]);
        if(level >= 10) level = 9;
        vice_ui -> toshowRegion((i - 1) / 10, (i - 1) % 10, level_color[level]);
    }
    this -> vice_ui -> resize(2400, 800);
}

int MainWindow::get_level(int maxn, int minn, int x) {
    maxn -= minn;
    x -= minn;
    if(x == maxn) return 9;
    if(x >= maxn * 0.316) return 8;
    if(x >= maxn * 0.1) return 7;
    if(x >= maxn * 0.0316) return 6;
    if(x >= maxn * 0.01) return 5;
    if(x >= maxn * 0.00316) return 4;
    if(x >= maxn * 0.001) return 3;
    if(x >= maxn * 0.000316) return 2;
    if(x >= maxn * 0.0001) return 1;
    return 0;
}


MainWindow::~MainWindow()
{
    delete ui;
}


