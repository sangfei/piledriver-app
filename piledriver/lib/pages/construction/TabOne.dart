import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/bean/StatBean.dart';
import 'package:piledriver/bean/ConstructionBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:piledriver/Utils/pie.dart';
import 'package:piledriver/Utils/cache_util.dart';

class TabOne extends StatefulWidget {
  final WorkRegionBean workRegion;

  TabOne(this.workRegion);

  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<StatBean> detailReportList = [];
  List<StatBean> equipmentStatDatas = [];
  List<StatBean> workRegionStatDatas = [];
  bool loading1 = true;
  bool loading2 = true;
  bool loading3 = true;

  List<Widget> widgetList = List();
  static DateTime datenow = CacheUtil.getInstance().getTime() == null
      ? DateTime.now()
      : CacheUtil.getInstance().getTime();
  String now = DateFormat('yyyy-MM-dd').format(datenow);
  static DateTime nextDay =
      new DateTime.utc(datenow.year, datenow.month, datenow.day)
          .add(new Duration(days: 1));
  String utcStartTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(datenow))
      .millisecondsSinceEpoch
      .toString();
  String utcEndTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(nextDay))
      .millisecondsSinceEpoch
      .toString();
  @override
  void initState() {
    print("init");
    super.initState();

    datenow = CacheUtil.getInstance().getTime() == null
        ? DateTime.now()
        : CacheUtil.getInstance().getTime();
    now = DateFormat('yyyy-MM-dd').format(datenow);
    nextDay = new DateTime.utc(datenow.year, datenow.month, datenow.day)
        .add(new Duration(days: 1));
    utcStartTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(datenow))
        .millisecondsSinceEpoch
        .toString();
    utcEndTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(nextDay))
        .millisecondsSinceEpoch
        .toString();

    getApiData();
    getEquipmentStatData();
    getWorkRegionStatData();
  }

  @override
  void dispose() {
    super.dispose();
    widgetList.clear();
  }

  @override
  Widget build(BuildContext context) {
    var content;

    print("loading1 status : " + loading1.toString());
    print("loading2 status : " + loading2.toString());

    print("loading3 status : " + loading3.toString());

    if (loading1 || loading2 || loading3) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = buildContent();
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: content,
    );
  }

  Widget buildEmptyContent() {
    widgetList.clear();
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildHeader()),
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: <Widget>[
          new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widgetList[index];
              },
              childCount: widgetList.length,
            ),
          )
        ]));
  }

  Widget buildContent() {
    widgetList.clear();
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildHeader()),
    );
    loadChartData();
    return new Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: <Widget>[
          new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widgetList[index];
              },
              childCount: widgetList.length,
            ),
          )
        ]));
  }

  void loadChartData() async {
    if (workRegionStatDatas.isNotEmpty && workRegionStatDatas[0].pieces != 0.0) {
      widgetList.add(
        Container(
          color: Colors.blue[100],
          width: (MediaQuery.of(context).size.width),
          height: 22.0,
          child: Text("  按设备统计 -- 当日"),
        ),
      );
      widgetList.add(
        Padding(padding: new EdgeInsets.only(bottom: 20.0)),
      );
      if (equipmentStatDatas.isNotEmpty) {
        widgetList.add(
          new SizedBox(
              height: 200.0,
              width: (MediaQuery.of(context).size.width),
              child: new DonutAutoLabelChart.withGivingData(
                  equipmentStatDatas, 'g_equipment_s_workregion')),
        );
      }
    }

    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  按设备统计 -- 累计"),
      ),
    );
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    if (equipmentStatDatas.isNotEmpty) {
      widgetList.add(
        new SizedBox(
            height: 200.0,
            width: (MediaQuery.of(context).size.width),
            child: new DonutAutoLabelChart.withGivingData(
                equipmentStatDatas, 'total')),
      );
    }

    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  施工详情 -- 当日"),
      ),
    );
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildDetailHeader()),
    );
    buildContructionDetail();
  }

  Future getApiData() async {
    var url = Constant.baseUrl +
        '/api/v1/construction/stat?start=' +
        utcStartTime.toString() +
        '&end=' +
        utcEndTime.toString() +
        '&workregionid=${widget.workRegion.id}'+
        '&type=all';
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        print("datas");
        detailReportList = StatBean.decodeData(jsonData);
        loading1 = false;
      });
    }
  }

  Future getWorkRegionStatData() async {
    var url = Constant.baseUrl +
        '/api/v1/construction/stat?start=' +
        utcStartTime.toString() +
        '&end=' +
        utcEndTime.toString() +
        '&workregionid=${widget.workRegion.id}' +
        '&type=g_workregion_s_workregion';
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        print("workRegionStatDatas");
        workRegionStatDatas = StatBean.decodeData(jsonData);
        loading2 = false;
      });
    }
  }

  Future getEquipmentStatData() async {
    var url = Constant.baseUrl +
        '/api/v1/construction/stat?start=' +
        utcStartTime.toString() +
        '&end=' +
        utcEndTime.toString() +
        '&workregionid=${widget.workRegion.id}' +
        '&type=g_equipment_s_workregion';
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        print("equipmentStatDatas");
        equipmentStatDatas = StatBean.decodeData(jsonData);
        loading3 = false;
      });
    }
  }

  // 每个条目���信息
  buildContructionDetail() {
    for (int i = 0; i < detailReportList.length; i++) {
      StatBean data = detailReportList[i];
      _buildRow(i, data);
    }
  }

  insertDiviver(widgets) {
    widgets.add(new Container(
      height: 14.0,
      width: 1.0,
      decoration: new BoxDecoration(
          border: new BorderDirectional(
              start: new BorderSide(color: Colors.black12, width: 1.0))),
    ));
  }

  _buildDetailHeader() {
    List<Widget> widgets = [];
    // var date = new DateTime.fromMillisecondsSinceEpoch(utc*1000);
    // var now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 4,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 17.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "序号",
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 4,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 17.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "设备号",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 4,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 17.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "责任人",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 4,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 17.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "成桩量",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );

    return widgets;
  }

  _buildHeader() {
    StatBean data = new StatBean();
    StatBean dataTotal = new StatBean();

    if (workRegionStatDatas.isNotEmpty) {
      for (int i = 0; i < workRegionStatDatas.length; i++) {
        dataTotal = workRegionStatDatas[i];

        data = workRegionStatDatas[i];
      }
    }

    List<Widget> widgets = [];
    // var date = new DateTime.fromMillisecondsSinceEpoch(utc*1000);
    // var now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 3,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "日期",
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  new Container(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            now,
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                          ),
                          new SizedBox(
                              height: 18.0,
                              width: 18.0,
                              child: new IconButton(
                                padding: new EdgeInsets.all(0.0),
                                icon:
                                    new Icon(Icons.arrow_drop_down, size: 18.0),
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      onChanged: (date) {}, onConfirm: (date) {
                                    setState(() {
                                      now =
                                          DateFormat('yyyy-MM-dd').format(date);
                                      utcStartTime = DateTime.parse(now)
                                          .millisecondsSinceEpoch
                                          .toString();
                                      DateTime nextDay = new DateTime.utc(
                                              date.year, date.month, date.day)
                                          .add(new Duration(days: 1));
                                        String  nextDayStr =
                                          DateFormat('yyyy-MM-dd').format(nextDay);
                                      utcEndTime = DateTime.parse(nextDayStr)
                                          .millisecondsSinceEpoch
                                          .toString();
                                      detailReportList = [];
                                      equipmentStatDatas = [];
                                      workRegionStatDatas = [];
                                      loading1 = true;
                                      loading2 = true;
                                      loading3 = true;
                                      getApiData();
                                      getEquipmentStatData();
                                      getWorkRegionStatData();
                                      CacheUtil.getInstance().setTime(date);
                                    });
                                  },
                                      currentTime: DateTime.parse(now),
                                      locale: 'zh');
                                },
                              ))
                        ]),
                  ),
                ],
              ),
            )),
      ),
    );
    insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 3,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "累计成桩",
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  new Container(
                    child: new Text(
                      dataTotal.totalpieces.toString(),
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) / 3,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "当日成桩",
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  new Container(
                    child: new Text(
                      data.pieces.toString(),
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );

    return widgets;
  }

  oneRowOfDetail(i, Color clr) {
    return new Container(
      width: (MediaQuery.of(context).size.width - 6.0) / 4,
      child: new FlatButton(
          onPressed: () {},
          child: new Container(
            height: 17.0,
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Text(
                    i.toString(),
                    style: new TextStyle(fontSize: 12.0, color: clr),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildRow(int i, StatBean data) {
    // var date = new DateTime.fromMillisecondsSinceEpoch(utc*1000);
    widgetList.add(new Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            oneRowOfDetail(i, Colors.grey),
            oneRowOfDetail(data.equipmentname, Colors.black),
            oneRowOfDetail(data.ownername, Colors.black),
            oneRowOfDetail(data.pieces, Colors.black),
          ]),
      decoration: const BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
                width: 1.0, color: const Color.fromRGBO(215, 217, 220, 1.0)),
          ),
          color: Colors.white),
    ));
  }
}
