import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:piledriver/bean/ProjectBean.dart';
import 'package:flutter/cupertino.dart';
import 'package:piledriver/pages/ConstructionPage.dart';
import 'package:piledriver/pages/workregion/NewWorkregionPage.dart';
import 'package:piledriver/pages/WorkRegion.dart';

class TabOne extends StatefulWidget {
  final ProjectBean project;

  TabOne(this.project);

  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<WorkRegionBean> datas = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (datas.isEmpty) {
      if (loading) {
        content = new Center(
          child: new CircularProgressIndicator(),
        );
      } else {
        content = new Center(
          child: new Text('没有数据'),
        );
      }
    } else {
      content = new ListView(
          padding: const EdgeInsets.all(1.0),
          children: buildStuffItems(widget.project));
    }

    return new Scaffold(
      body: content,
      floatingActionButton: new Padding(
        padding: EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new NewWorkregionPage(widget.project);
            }));
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget add() {
    return new Container(
      child: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Future getApiData() async {
    var url = Constant.baseUrl +
        '/api/v1/workregion?projectid=${widget.project.projectID}';
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        datas = WorkRegionBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  // 每个条目的信息
  buildStuffItems(ProjectBean project) {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      WorkRegionBean data = datas[i];
      var gd = _buildRow(data, project);
      widgets.add(gd);
    }

    return widgets;
  }

  Widget _buildRow(WorkRegionBean data, ProjectBean project) {
    return new Container(
      child: new ListTile(
        leading: new Icon(
          Icons.landscape,
          color: Colors.orange,
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        title: new Text(data.name),
        onTap: () {
          Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) =>
                      ConstructionPage( data,project)));
        },
        enabled: true,
      ),
      decoration: const BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
                width: 1.0, color: const Color.fromRGBO(215, 217, 220, 1.0)),
          ),
          color: Colors.white),
    );
  }
}
