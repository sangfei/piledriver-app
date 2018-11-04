import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/StatBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:piledriver/Utils/cache_util.dart';
import 'package:piledriver/bean/ProjectBean.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;

class TabOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> with SingleTickerProviderStateMixin {
  List<StatBean> projectStatDatas = [];
  bool loading2 = true;
  List<Widget> widgetList = List();

  static DateTime datenow = CacheUtil.getInstance().getTime() == null
      ? DateTime.now()
      : CacheUtil.getInstance().getTime();

  static DateTime aweekAgo =
      new DateTime.utc(datenow.year, datenow.month, datenow.day)
          .add(new Duration(days: -7));

  String utcStartTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(datenow))
      .millisecondsSinceEpoch
      .toString();

  String utcEndTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(aweekAgo))
      .millisecondsSinceEpoch
      .toString();
  String startTimeFormat = DateFormat('yyyy-MM-dd').format(aweekAgo);
  String endTimeFormat = DateFormat('yyyy-MM-dd').format(datenow);

  @override
  void initState() {
    super.initState();
    var enddate = CacheUtil.getInstance().getEndTime() == null
        ? DateTime.now()
        : CacheUtil.getInstance().getEndTime();
    endTimeFormat = DateFormat('yyyy-MM-dd').format(enddate);
    var aweekAgo = new DateTime.utc(enddate.year, enddate.month, enddate.day)
        .add(new Duration(days: -7));
    var startdate = CacheUtil.getInstance().getTime() == null
        ? aweekAgo
        : CacheUtil.getInstance().getTime();
    startTimeFormat = DateFormat('yyyy-MM-dd').format(startdate);
    utcStartTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(startdate))
        .millisecondsSinceEpoch
        .toString();
    utcEndTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(enddate))
        .millisecondsSinceEpoch
        .toString();
    getProjectStatData();
  }

  @override
  void dispose() {
    super.dispose();
    widgetList.clear();
  }

  @override
  Widget build(BuildContext context) {
    var content;

    print("loading2 status : " + loading2.toString());

    if (loading2) {
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
    buildTabField();

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
          ),
        ]));
  }

  void buildTabField() {
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildDetailHeader()),
    );
    buildContructionDetail();
  }


  Future getProjectStatData() async {
    var url = Constant.baseUrl +
        '/api/v1/construction/stat?start=' +
        utcStartTime.toString() +
        '&end=' +
        utcEndTime.toString() +
        '&type=g_project';
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        projectStatDatas = StatBean.decodeData(jsonData);
        loading2 = false;
      });
    }
  }

  // 每个条目���信息
  buildContructionDetail() {
    for (int i = 0; i < projectStatDatas.length; i++) {
      StatBean dataCurrent = projectStatDatas[i];
      StatBean dataTotal = projectStatDatas[i];

      _buildRow(i, dataTotal, dataCurrent);
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

  Widget buildOneTabViewHeaderColumn(String header, double columnNumber) {
    return new Container(
      width: (MediaQuery.of(context).size.width - 6.0) * columnNumber,
      child: new FlatButton(
          onPressed: () {},
          child: new Container(
            height: 17.0,
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    header,
                    style: new TextStyle(fontSize: 12.0, color: Colors.black),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<Widget> _buildDetailHeader() {
    List<Widget> widgets = [];
    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  按项目统计："),
      ),
    );
    widgets.add(buildOneTabViewHeaderColumn('项目', 0.45));

    insertDiviver(widgets);
    widgets.add(buildOneTabViewHeaderColumn('累计成桩', 0.25));

    insertDiviver(widgets);
    widgets.add(buildOneTabViewHeaderColumn('时间段内成桩', 0.3));

    return widgets;
  }

  _buildHeader() {
    double data = 0.0;
    double dataTotal = 0.0;
    List<StatBean> stateList = projectStatDatas;
    if (stateList.isNotEmpty) {
      for (int i = 0; i < stateList.length; i++) {
        dataTotal += stateList[i].totalpieces;
        data += stateList[i].pieces;
      }
    }

    List<Widget> widgets = [];
    // var date = new DateTime.fromMillisecondsSinceEpoch(utc*1000);
    // var now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) * 0.4,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 60.0,
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
                          new Column(children: <Widget>[
                            new Text(
                              startTimeFormat,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            new Text(
                              "-",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            new Text(
                              endTimeFormat,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                          ]),
                          new SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child: new IconButton(
                                padding: new EdgeInsets.all(0.0),
                                icon:
                                    new Icon(Icons.arrow_drop_down, size: 22.0),
                                onPressed: () {
                                  showPickerDateRange(context);
                                }),
                          )
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
        width: (MediaQuery.of(context).size.width - 6.0) *0.3,
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
                      dataTotal.toString(),
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
        width: (MediaQuery.of(context).size.width - 6.0) * 0.3,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "时间段内成桩",
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  new Container(
                    child: new Text(
                      data.toString(),
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

  oneRowOfDetail(i, Color clr, double columnSize) {
    return new Container(
      width: (MediaQuery.of(context).size.width - 6.0) * columnSize,
      child: new FlatButton(
          onPressed: () {},
          child: new Container(
            height: 17.0,
            child: new Column(
              children: <Widget>[
                new Expanded(
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

  showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
            value: DateTime.parse(startTimeFormat),
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true,
            year_suffix: "年",
            month_suffix: "月",
            day_suffix: "日"),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
          startTimeFormat = DateFormat('yyyy-MM-dd')
              .format((picker.adapter as DateTimePickerAdapter).value);
          utcStartTime = DateTime.parse(DateFormat('yyyy-MM-dd')
                  .format((picker.adapter as DateTimePickerAdapter).value))
              .millisecondsSinceEpoch
              .toString();
        });

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD,
            value: DateTime.parse(endTimeFormat),
            isNumberMonth: true,
            year_suffix: "年",
            month_suffix: "月",
            day_suffix: "日"),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
          DateTime selectDate = (picker.adapter as DateTimePickerAdapter).value;
          endTimeFormat = DateFormat('yyyy-MM-dd').format(selectDate);
          DateTime nextDay = new DateTime.utc(
                  selectDate.year, selectDate.month, selectDate.day)
              .add(new Duration(days: 1));
          utcEndTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(nextDay))
              .millisecondsSinceEpoch
              .toString();
        });

    List<Widget> actions = [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text("取消")),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
            setState(() {
              projectStatDatas = [];
              loading2 = true;
              getProjectStatData();
              CacheUtil.getInstance().setTime(DateTime.parse(startTimeFormat));
              CacheUtil.getInstance().setEndTime(DateTime.parse(endTimeFormat));
            });
          },
          child: new Text("确定"))
    ];

    Dialog.showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("选择日期范围"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("开始日期:"),
                  ps.makePicker(),
                  Text("结束日期:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }

  _buildRow(int i, StatBean dataTotal, StatBean dataCurrent) {
    widgetList.add(new Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            oneRowOfDetail(dataTotal.projectname, Colors.black, 0.45),
            oneRowOfDetail(dataTotal.totalpieces, Colors.black, 0.25),
            oneRowOfDetail(dataCurrent.pieces, Colors.black, 0.3),
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
