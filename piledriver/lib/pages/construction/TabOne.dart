import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/bean/ConstructionBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:piledriver/pages/construction/pie.dart';

class TabOne extends StatefulWidget {
  final WorkRegionBean workRegion;

  TabOne(this.workRegion);

  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<ConstructionBean> datas = [];
  List<Widget> widgetList = List();
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  void dispose() {
    super.dispose();
    widgetList.clear();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (datas.isEmpty) {
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
    widgetList.clear();
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildHeader()),
    );
    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  按排号统计"),
      ),
    );
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    widgetList.add(
      new SizedBox(
          height: 200.0,
          width: (MediaQuery.of(context).size.width),
          child: new DonutAutoLabelChart.withSampleData()),
    );

    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  按班组统计"),
      ),
    );
    widgetList.add(
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
    );
    widgetList.add(
      new SizedBox(
          height: 200.0,
          width: (MediaQuery.of(context).size.width),
          child: new DonutAutoLabelChart.withSampleData()),
    );

    widgetList.add(
      Container(
        color: Colors.blue[100],
        width: (MediaQuery.of(context).size.width),
        height: 22.0,
        child: Text("  施工详情"),
      ),
    );
    widgetList.add(
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildDetailHeader()),
    );
    buildContructionDetail();

    //  new Container(
    //     // color: Colors.white54,
    //     child: new Padding(
    //         padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    //         child: new Column(children: <Widget>[
    //           Padding(padding: new EdgeInsets.only(top: 10.0)),
    //           new Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: _buildHeader()),
    //           Container(
    //             color: Colors.grey,
    //             width: (MediaQuery.of(context).size.width - 30.0),
    //             height: 0.3,
    //           ),
    //           Padding(padding: new EdgeInsets.only(top: 20.0)),
    //           new SizedBox(
    //               height: (MediaQuery.of(context).size.width) * 0.6,
    //               width: (MediaQuery.of(context).size.width),
    //               child: new DonutAutoLabelChart.withSampleData()),
    //           Padding(padding: new EdgeInsets.only(top: 10.0)),
    // Container(
    //   color: Colors.blue[100],
    //   width: (MediaQuery.of(context).size.width),
    //   height: 22.0,
    //   child: Text("  施工详情"),
    // ),
    //   new Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: _buildDetailHeader()),
    //   Flexible(
    //       child: new ListView(
    //           padding: const EdgeInsets.all(1.0),
    //           children: buildContructionDetail()))
    // ])));
  }

  Future getApiData() async {
    print("get construction");
    var url = Constant.baseUrl +
        '/api/v1/construction?start=1535789325&end=1535789326&workregion=${widget.workRegion.id}';
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        datas = ConstructionBean.decodeData(jsonData);
      });
    }
  }

  // 每个条目的信息
  buildContructionDetail() {
    for (int i = 0; i < datas.length; i++) {
      ConstructionBean data = datas[i];
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
    ConstructionBean data = datas[0];
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
                      "桩号",
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
                      "排号",
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
                      "桩长",
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
    ConstructionBean data = datas[0];
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
                      data.pieces.toString(),
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

  OneRowOfDetail(i, Color clr) {
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

  _buildRow(int i, ConstructionBean data) {
    // var date = new DateTime.fromMillisecondsSinceEpoch(utc*1000);
    widgetList.add(new Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            OneRowOfDetail(i, Colors.grey),
            OneRowOfDetail(data.pieces, Colors.black),
            OneRowOfDetail(data.pieces, Colors.black),
            OneRowOfDetail(data.pieces, Colors.black),
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
