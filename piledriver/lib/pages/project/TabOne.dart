import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/projectBean.dart';
import 'package:piledriver/pages/projectDetail.dart';
import 'package:piledriver/common/constant.dart';

class TabOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<ProjectBean> datas = [];

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (datas.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView(children: buildMovieItems());
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
      });
    }
    var castsAcatars = datas[0].projectName;
    print("castsAcatars");
    print("第一个条目的数据：" + castsAcatars);
  }

  // 每个条目的信息
  buildMovieItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      ProjectBean data = datas[i];
      var gd = new GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new ProjectDetail(data);
          }));
        },
        child: new Column(
          children: <Widget>[
            //todo 在脑袋要构思出 这个布局的整体的结构
            new Row(
              children: <Widget>[
                buildImage(data),
                new Expanded(child: buildMsg(data)),
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
    var src =
        "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2535191502.jpg";
    return new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: new Image.network(
        src,
        width: 140.0,
        height: 160.0,
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
        new Text(data.projectID.toString()),
        // new Text(data.total),
        // new Text(data.ratingAverage),
        // new Text(
        //   data.collect_count,
        //   style: new TextStyle(fontSize: 13.0, color: Colors.green),
        // ),
      ],
    );
  }
}
