#include "vicewindow.h"


ViceWindow::ViceWindow(QWidget *parent) : QWidget(parent)   {

    cnt = 0;
    for(int i = 1; i <= 100; i++) is_chosen[i] = false;


    font1 = new QFont();
    font2 = new QFont();
    font1 -> setPointSize(12);
    font2 -> setPointSize(10);
    QTB = new QTabWidget(this);
    mainw1 = new QWidget(this);
    mainw2 = new QWidget(this);
    w1 = new QWidget(this);
    w2 = new QWidget(this);
    w11 = new QWidget(w1);
    w10 = new QWidget(w1);
    w12 = new QWidget(w1);
    w120 = new QWidget(w12);
    w121 = new QWidget(w12);
    w22 = new QWidget(w2);
    w21 = new QWidget(w2);
    w221 = new QWidget(w22);
    c01 = new QRadioButton("the Number of Order", w10);
    c02 = new QRadioButton("the Distribution of Travel Time", w10);
    c03 = new QRadioButton("the Distribution of Order Fees", w10);
    c11 = new QRadioButton("Line Chart", w11);
    c12 = new QRadioButton("Histogram", w11);
    c13 = new QRadioButton("Pie Chart", w11);
    c21 = new QRadioButton("All");
    c22 = new QRadioButton("Customed");
    c23 = new QRadioButton("Departure Area");
    c24 = new QRadioButton("End Area");
    c31 = new QRadioButton("Departure Time");
    c32 = new QRadioButton("End Time");
    c01 -> setFont(*font2);
    c02 -> setFont(*font2);
    c03 -> setFont(*font2);
    c11 -> setFont(*font2);
    c12 -> setFont(*font2);
    c13 -> setFont(*font2);
    c21 -> setFont(*font2);
    c22 -> setFont(*font2);
    c23 -> setFont(*font2);
    c24 -> setFont(*font2);
    c31 -> setFont(*font2);
    c32 -> setFont(*font2);
    chart = new QChart();
    cv = new QChartView(chart);
    QBG0 = new QButtonGroup(w10);
    QBG1 = new QButtonGroup(w11);
    QBG21 = new QButtonGroup(w121);
    QBG22 = new QButtonGroup(w120);
    QBG3 = new QButtonGroup(w221);

    mapView = new QQuickWidget(mainw1);
    QUrl source("qrc:/MyMap.qml");
    mapView -> setSource(source);
    mapView -> engine() -> rootContext() -> setContextProperty("viceWindow", this);
    mapView -> setResizeMode(QQuickWidget::SizeRootObjectToView);
    map_root = mapView -> rootObject();

    mapView2 = new QQuickWidget(mainw2);
    QUrl source2("qrc:/MyMap2.qml");
    mapView2 -> setSource(source2);
    mapView2 -> engine() -> rootContext() -> setContextProperty("viceWindow", this);
    mapView2 -> setResizeMode(QQuickWidget::SizeRootObjectToView);
    map_root2 = mapView2 -> rootObject();

    mainLayout = new QHBoxLayout(this);
    mainLayout1 = new QHBoxLayout(mainw1);
    mainLayout2 = new QVBoxLayout(mainw2);
    layout1 = new QVBoxLayout(w1);
    layout2 = new QVBoxLayout(w2);
    layout10 = new QVBoxLayout(w10);
    layout11 = new QVBoxLayout(w11);
    layout12 = new QVBoxLayout(w12);
    layout21 = new QVBoxLayout(w21);
    layout120 = new QGridLayout(w120);
    layout121 = new QVBoxLayout(w121);
    layout22 = new QHBoxLayout(w22);
    layout221 = new QVBoxLayout(w221);

    QBG0 -> addButton(c01);
    QBG0 -> addButton(c02);
    QBG0 -> addButton(c03);
    c01 -> setChecked(true);

    QBG1 -> addButton(c11);
    QBG1 -> addButton(c12);
    QBG1 -> addButton(c13);
    c13 -> setEnabled(false);
    c11 -> setChecked(true);

    QBG21 -> addButton(c21);
    QBG21 -> addButton(c22);
    c21 -> setChecked(true);

    QBG22 -> addButton(c23);
    QBG22 -> addButton(c24);
    c23 -> setChecked(true);

    QBG3 -> addButton(c31);
    QBG3 -> addButton(c32);
    c31 -> setChecked(true);


//part 1 begin.....................................................................................................................................

    QLabel* label1 = new QLabel("Analysis Data", w10);
    label1 -> setFont(*font1);
    layout10 -> addWidget(label1);
    layout10 -> addWidget(c01);
    layout10 -> addWidget(c02);
    layout10 -> addWidget(c03);
    w10 -> setLayout(layout10);

    QLabel* label2 = new QLabel("Chart Pattern", w11);
    label2 -> setFont(*font1);
    layout11 -> addWidget(label2);
    layout11 -> addWidget(c11);
    layout11 -> addWidget(c12);
    layout11 -> addWidget(c13);
    layout11 -> addWidget(new QLabel("Pie Chart option will be"));
    layout11 -> addWidget(new QLabel("available if choose various areas"));
    w11 -> setLayout(layout11);

    layout120 -> addWidget(c21, 0, 0);
    layout120 -> addWidget(c23, 0, 1);
    layout120 -> addWidget(c22, 1, 0);
    layout120 -> addWidget(c24, 1, 1);
    w120 -> setLayout(layout120);

    QLabel* qls;
    for(int i = 0; i < 5; i++) {
        auto z = new QWidget(w121);
        auto l = new QHBoxLayout(z);
        s21[i] = new QSpinBox(z);
        s21[i] -> setMinimum(0);
        s21[i] -> setMaximum(100);
        qls = new QLabel("Area", z);
        qls -> setFont(*font2);
        l -> addWidget(qls);
        l -> addWidget(s21[i]);
        l -> addStretch();
        z -> setLayout(l);
        layout121 -> addWidget(z);
    }
    layout121 -> addWidget(new QLabel("Select 0 if the series is not needed"));
    layout121 -> addWidget(new QLabel("You could also select or cancel an area"));
    layout121 -> addWidget(new QLabel("by clicking it on the map"));
    w121 -> setLayout(layout121);
    w121 -> setEnabled(false);

    QLabel* label3 = new QLabel("Area Option", w1);
    label3 -> setFont(*font1);
    layout12 -> addWidget(label3);
    layout12 -> addWidget(w120);
    layout12 -> addWidget(w121);
    w12 -> setLayout(layout12);

    layout1 -> addWidget(w10);
    layout1 -> addStretch();
    layout1 -> addWidget(w11);
    layout1 -> addStretch();
    layout1 -> addWidget(w12);
    w1 -> setLayout(layout1);

 //part1 end.....................................................................................................................

 //part2 begin...................................................................................................................

    layout21 -> addWidget(cv);
    w21 -> setLayout(layout21);

    layout221 -> addWidget(c31);
    layout221 -> addWidget(c32);
    w221 -> setLayout(layout221);

    startDay = new QSpinBox(w22);
    startDay -> setMinimum(20161101);
    startDay -> setMaximum(20161115);
    endDay = new QSpinBox(w22);
    endDay -> setMinimum(20161101);
    endDay -> setMaximum(20161115);

    startHour = new QSpinBox(w22);
    startHour -> setMinimum(0);
    startHour -> setMaximum(24);
    endHour = new QSpinBox(w22);
    endHour -> setMinimum(0);
    endHour -> setMaximum(24);

    timeStep = new QDoubleSpinBox(w22);
    timeStep -> setMinimum(0.5);
    timeStep -> setMaximum(72);
    timeStep -> setSingleStep(0.5);

    Draw = new QPushButton("Plot Chart", w22);
    HeatMap = new QPushButton("Show Heat Map", w22);
    Draw -> setFont(*font2);
    HeatMap -> setFont(*font2);

    layout22 -> addWidget(w221);
    layout22 -> addStretch();
    qls = new QLabel("Start Day", w22);
    qls -> setFont(*font2);
    layout22 -> addWidget(qls);
    layout22 -> addWidget(startDay);
    qls =new QLabel("Start Hour", w22);
    qls -> setFont(*font2);
    layout22 -> addWidget(qls);
    layout22 -> addWidget(startHour);
    qls = new QLabel("End Day", w22);
    qls -> setFont(*font2);
    layout22 -> addWidget(qls);
    layout22 -> addWidget(endDay);
    qls = new QLabel("End Hour", w22);
    qls -> setFont(*font2);
    layout22 -> addWidget(qls);
    layout22 -> addWidget(endHour);
    qls = new QLabel("Time Step(Hour)", w22);
    qls -> setFont(*font2);
    layout22 -> addWidget(qls);
    layout22 -> addWidget(timeStep);
    layout22 -> addStretch();
    layout22 -> addWidget(Draw);
    layout22 -> addWidget(HeatMap);
    w22 -> setLayout(layout22);


    layout2 -> addWidget(w21);
    QLabel* ql = new QLabel("Time Option");
    ql -> setFont(*font1);
    ql -> setAlignment(Qt::AlignCenter);
    layout2 -> addWidget(ql);
    layout2 -> addWidget(w22);

 //part2 end.....................................................................................................................

    mainLayout1 -> addWidget(w1);
    mainLayout1 -> addWidget(mapView);
    mainLayout1 -> addWidget(w2);
    mainw1 -> setLayout(mainLayout1);
    mapView -> show();

 //Window1 end....................................................................................................................

    x1 = new QWidget(mainw2);
    x2 = new QWidget(mainw2);
    xlayout1 = new QHBoxLayout(x1);
    xlayout2 = new QHBoxLayout(x2);


    qls = new QLabel("Start Latitude", x1);
    qls -> setFont(*font2);
    xlayout1 -> addWidget(qls);
    start_lat = new QDoubleSpinBox(x1);
    start_lat -> setMinimum(-90);
    start_lat -> setMaximum(90);
    start_lat -> setSingleStep(0.0000001);
    start_lat -> setDecimals(7);
    xlayout1 -> addWidget(start_lat);
    xlayout1 -> addStretch();
    qls = new QLabel("Start Longitude", x1);
    qls -> setFont(*font2);
    xlayout1 -> addWidget(qls);
    start_lng = new QDoubleSpinBox(x1);
    start_lng -> setMinimum(-180);
    start_lng -> setMaximum(180);
    start_lng -> setSingleStep(0.0000001);
    start_lng -> setDecimals(7);
    xlayout1 -> addWidget(start_lng);
    xlayout1 -> addStretch();
    qls = new QLabel("End Latitude", x1);
    qls -> setFont(*font2);
    xlayout1 -> addWidget(qls);
    end_lat = new QDoubleSpinBox(x1);
    end_lat -> setMinimum(-90);
    end_lat -> setMaximum(90);
    end_lat -> setSingleStep(0.0000001);
    end_lat -> setDecimals(7);
    xlayout1 -> addWidget(end_lat);
    xlayout1 -> addStretch();
    qls = new QLabel("End Longitude", x1);
    qls -> setFont(*font2);
    xlayout1 -> addWidget(qls);
    end_lng = new QDoubleSpinBox(x1);
    end_lng -> setMinimum(-180);
    end_lng -> setMaximum(180);
    end_lng -> setSingleStep(0.0000001);
    end_lng -> setDecimals(7);
    xlayout1 -> addWidget(end_lng);

    Navigate = new QPushButton("Navigate", x2);
    Navigate -> setFont(*font2);
    Navigate -> setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    xlayout2 -> addWidget(Navigate);

    x1 -> setLayout(xlayout1);
    x2 -> setLayout(xlayout2);

    mainLayout2 -> addWidget(mapView2);
    //mainLayout2 -> addStretch();   //..........................................Temporary for Format
    mainLayout2 -> addWidget(x1);
    mainLayout2 -> addWidget(x2);
    mainw2 -> setLayout(mainLayout2);

 //Window2 end....................................................................................................................
    QTB -> addTab(mainw1, "Data Analysis");
    QTB -> addTab(mainw2, "Navigation");


    mainLayout -> addWidget(QTB);
    this -> setWindowTitle("Analysis Window");
    this -> setLayout(mainLayout);
    this -> resize(2400, 800);

    for(int i = 0; i < 5; i++)
        connect(s21[i], SIGNAL(valueChanged(int)), this, SLOT(area_changed()));
    connect(start_lat, SIGNAL(valueChanged(double)), this, SLOT(show_points()));
    connect(start_lng, SIGNAL(valueChanged(double)), this, SLOT(show_points()));
    connect(end_lat, SIGNAL(valueChanged(double)), this, SLOT(show_points()));
    connect(end_lng, SIGNAL(valueChanged(double)), this, SLOT(show_points()));
    connect(this, SIGNAL(mouse_point(double, double)), this, SLOT(area_switch(double, double)));
    connect(c21, SIGNAL(toggled(bool)), this, SLOT(clear_custom(bool)));
    connect(map_root, SIGNAL(is_clicked(QVariant, QVariant)), this, SLOT(map_click(QVariant, QVariant)));
    connect(map_root2, SIGNAL(is_clicked(QVariant, QVariant)), this, SLOT(map_click2(QVariant, QVariant)));
    connect(c22, SIGNAL(toggled(bool)), this, SLOT(setPieChart(bool)));
    connect(c22, SIGNAL(toggled(bool)), w121, SLOT(setEnabled(bool)));
    connect(c01, SIGNAL(toggled(bool)), w11, SLOT(setEnabled(bool)));
    connect(Draw, SIGNAL(clicked()), this, SLOT(send()));
    connect(HeatMap, SIGNAL(clicked()), this, SLOT(heatsend()));
    connect(Navigate, SIGNAL(clicked()), this, SLOT(draw_route()));
}

void ViceWindow::show_points() {
    double orig_lat = start_lat -> value();
    double orig_lng = start_lng -> value();
    double dest_lat = end_lat -> value();
    double dest_lng = end_lng -> value();
    emit showPoint(0, orig_lng, orig_lat);
    emit showPoint(1, dest_lng, dest_lat);
}

void ViceWindow::draw_route() {
    double orig_lat = start_lat -> value();
    double orig_lng = start_lng -> value();
    double dest_lat = end_lat -> value();
    double dest_lng = end_lng -> value();
    emit showRoute(orig_lng, orig_lat, dest_lng, dest_lat);
}

void ViceWindow::clear_custom(bool x) {
    if(!x) {
        HeatMap -> setEnabled(false);
        clearRegion();
        return;
    }
    HeatMap -> setEnabled(true);
    for(int i = 0; i < 5; i++)
        s21[i] -> setValue(0);
}

void ViceWindow::area_changed() {
    clearRegion();
    for(int i = 1; i <= 100; i++) is_chosen[i] = 0;
    for(int i = 0; i < 5; i++) {
        int x = s21[i] -> value();
        if(x == 0) continue;
        is_chosen[x] = 1;
        showRegion((x - 1) / 10,(x - 1) % 10, "green");
    }
}

void ViceWindow::area_switch(double lat, double lng) {
    double x1 = (lat - 30.43414992) / 0.044966016;
    double y1 = (lng - 103.8038618) / 0.05229722;
    if(x1 < 0 || x1 > 10 || y1 < 0 || y1 > 10) return;
    int x = trunc(x1) * 10 + trunc(y1) + 1;
    if(is_chosen[x]) {
        for(int i = 0; i < 5; i++)
            if(s21[i] -> value() == x) {
                s21[i] -> setValue(0);
                return;
            }
    } else {
        for(int i = 0; i < 5; i++)
            if(s21[i] -> value() == 0) {
                s21[i] -> setValue(x);
                return;
            }
    }
}

void ViceWindow::map_click(QVariant lat, QVariant lng) {
    if(c22 -> isChecked()) emit mouse_point(lat.toDouble(), lng.toDouble());
}

void ViceWindow::map_click2(QVariant lat, QVariant lng) {
    double lat1 = lat.toDouble();
    double lng1 = lng.toDouble();
    if(!cnt) {
        start_lat -> setValue(lat1);
        start_lng -> setValue(lng1);
        cnt = 1;
    } else {
        end_lat -> setValue(lat1);
        end_lng -> setValue(lng1);
        cnt = 0;
    }
}

void ViceWindow::send() {
    int DataOption = (c01 -> isChecked() ? 1 : (c02 -> isChecked() ? 2 : 3));
    int ChartPattern = (c11 -> isChecked() ? 1 : (c12 -> isChecked() ? 2 : 3));
    int AreaOption1 = c21 -> isChecked() ? 1 : 2;
    int AreaOption2 = c23 -> isChecked() ? 1 : 2;
    int TimeOption = c31 -> isChecked() ? 1 : 2;
    emit click(DataOption, ChartPattern, AreaOption1, AreaOption2, TimeOption);
}

void ViceWindow::heatsend() {
    int AreaOption = c23 -> isChecked() ? 1 : 2;
    int TimeOption = c31 -> isChecked() ? 1 : 2;
    emit heatclick(AreaOption, TimeOption);
}

void ViceWindow::closeEvent(QCloseEvent *event){
    emit isClosed();
}

void ViceWindow::setPieChart(bool k) {
    if(!k)
        c11 -> setChecked(true);
    c13 -> setEnabled(k);
}
