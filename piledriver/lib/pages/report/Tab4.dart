import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/StatBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:piledriver/Utils/cache_util.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;

class TabFour extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabFourState();
  }
}

class TabFourState extends State<TabFour> with SingleTickerProviderStateMixin {
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

    return content;
  }

  Widget buildContent() {
    widgetList.clear();
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 10.0)),
    );
    widgetList.add(Container(
      color: Colors.white,
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildOneHeaderName()),
    ));
    widgetList.add(Container(
      color: Colors.white,
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildHeader()),
    ));
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 10.0)),
    );
    buildTabField();

    return new Scaffold(
        backgroundColor: Color.fromRGBO(232, 238, 245, 0.5),
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
          mainAxisAlignment: MainAxisAlignment.start,
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
        '&type=g_owner';
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

  // insertDiviver(widgets) {
  //   widgets.add(new Container(
  //     height: 30.0,
  //     width: 1.0,
  //     color: Colors.red,
  //     margin: const EdgeInsets.only(left: 1.0, right: 1.0),
  //   ));
  // }

  Widget buildOneTabViewHeaderColumn(String header, double columnNumber) {
    return new Container(
      padding: new EdgeInsets.only(top: 15.0),
      child: new Align(
        child: new Text(
          header,
          style: new TextStyle(
              fontSize: 12.0, color: Colors.blueGrey),
        ),
      ),
    );
  }

  List<Widget> _buildDetailHeader() {
    List<Widget> widgets = [];

    widgetList.add(
      Container(
        color: Colors.white,
        width: (MediaQuery.of(context).size.width * 0.9),
        height: 30.0,
        padding: new EdgeInsets.only(top: 10.0, left: 5.0),
        child: Text(
          "按负责人统计：",
          style: new TextStyle(
              fontSize: 12.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
    widgets.add(oneHeaderName('姓名', 0.45));

    // insertDiviver(widgets);
    widgets.add(oneHeaderName('累计成桩', 0.25));

    // insertDiviver(widgets);
    widgets.add(oneHeaderName('时间段内成桩', 0.3));

    return widgets;
  }

  Widget oneHeaderName(name, widthRatio) {
    return new Container(
      color: Colors.white,
      width: (MediaQuery.of(context).size.width - 6.0) * widthRatio,
      child: new Container(
          height: 50.0,
          child: new Center(
            child: new Container(
              child: new Text(
                name,
                style: new TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey),
              ),
            ),
          )),
    );
  }

  _buildOneHeaderName() {
    List<Widget> widgets = [];

    widgets.add(oneHeaderName('日期', 0.45));
    widgets.add(oneHeaderName('累计成桩', 0.25));
    widgets.add(oneHeaderName('时间段内成桩', 0.3));
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
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) *0.45,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 60.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Column(children: <Widget>[
                            new Text(
                              "开始："+startTimeFormat,
                              style: new TextStyle(
                                fontSize: 10.0,
                                color: Color.fromRGBO(0, 0, 0, 1.0),
                              ),
                            ),
                           
                            new Text(
                              "结束："+endTimeFormat,
                              style: new TextStyle(
                                  fontSize: 10.0,
                                  color: Color.fromRGBO(0, 0, 0, 1.0)),
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
    // insertDiviver(widgets);
    widgets.add(
      new Container(
        width: (MediaQuery.of(context).size.width - 6.0) *0.25,
        child: new FlatButton(
            onPressed: () {},
            child: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      dataTotal.toInt().toString(),
                      style: new TextStyle(
                          fontSize: 18.0, color: Colors.deepOrangeAccent),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
    // insertDiviver(widgets);
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
                      data.toInt().toString(),
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(114, 203, 126, 1.0)),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );

    return widgets;
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

  oneRowOfDetail(i, Color clr, double columnSize) {
    return new Container(
      padding: new EdgeInsets.only(top: 15.0, bottom: 5.0),
      width: (MediaQuery.of(context).size.width - 6.0) * columnSize,
      child: new Align(
        child: new Text(
          i.toString(),
          style: new TextStyle(fontSize: 12.0, color: clr),
        ),
      ),
    );
  }

  _buildRow(int i, StatBean dataTotal, StatBean dataCurrent) {
    widgetList.add(new Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            oneRowOfDetail(dataTotal.ownername, Colors.black, 0.45),
            oneRowOfDetail(dataTotal.totalpieces.toInt(), Colors.black, 0.25),
            oneRowOfDetail(dataCurrent.pieces.toInt(),
                Color.fromRGBO(114, 203, 126, 1.0), 0.3),
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
