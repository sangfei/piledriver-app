import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/ProjectBean.dart';
import 'package:piledriver/pages/WorkRegion.dart';
import 'package:piledriver/common/constant.dart';

class TabOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<ProjectBean> datas = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  void dispose() {
    super.dispose();
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
      content = new ListView(children: buildProjectItems());
    }

    return new Scaffold(
      body: content,
    );
  }

  Future getApiData() async {
    //当前的项目列表
    var url = Constant.baseUrl + "/api/v1/project";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        datas = ProjectBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  // 每个条目的信息
  buildProjectItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      ProjectBean data = datas[i];
      var gd = new GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new WorkRegionPage(data);
          }));
        },
        child: new Column(
          children: <Widget>[
            //todo 在脑袋要构思出 这个布局的整体的结构
            new Row(
              children: <Widget>[
                buildImage(data),
                new Expanded(
                    child: new Padding(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: buildMsg(data))),
                const Icon(Icons.arrow_forward)
              ],
            ),
          ],
        ),
      );
      widgets.add(gd);
    }

    return widgets;
  }

  buildImage(ProjectBean data) {
    var imgname = "P${data.projectID}";
    var src = Constant.baseUrl + "image/load/$imgname.jpg";
    return new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 0.0,
      ),
      child: new Image.network(
        src,
        width: 70.0,
        height: 80.0,
      ),
    );
  }

  buildMsg(ProjectBean data) {
    return new Column(
      //每个孩子的边缘对其
      crossAxisAlignment: CrossAxisAlignment.start,
      //最大限度地减少自由空间沿主轴，受传入的布局限制。
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          data.projectName,
          textAlign: TextAlign.left,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        new Text("项目详情：" + data.projectDetail),
        // new Text(data.projectID.toString()),
      ],
    );
  }
}
