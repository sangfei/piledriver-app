import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/stuffBean.dart';
import 'package:piledriver/common/constant.dart';
class TabOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne> {
  List<StuffBean> datas = [];

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
      content = new ListView(children: buildStuffItems());
    }
    return new Scaffold(
      body: content,
    );
  }

  Future getApiData() async {
    //豆瓣电影最近的正在播放的电影
    var url =
        Constant.baseUrl + "/api/v1/list/stuff";

//    Dio dio = new Dio();
//    Response response=await dio.get(url);
//    print(response.data);
////    setState(() {
////   });
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        datas = StuffBean.decodeData(jsonData);
      });
    }
  }

  // 每个条目的信息
  buildStuffItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      StuffBean data = datas[i];
      var gd = new GestureDetector(
        onTap: () {
         // BindTab();
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

  buildImage(StuffBean data) {
        var imgname = "S${data.stuffID}";
    var src = Constant.baseUrl + "image/load/$imgname.jpg";
     return new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: new Image.network(
        src,
        width: 80.0,
        height: 100.0,
      ),
    );
  }

  buildMsg(StuffBean data) {
    return new Column(
      //每个孩子的边缘对其
      crossAxisAlignment: CrossAxisAlignment.start,
      //最大限度地减少自由空间沿主轴，受传入的布局限制。
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          data.name,
          textAlign: TextAlign.left,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        new Text("性别：" + data.sex),
        new Text("生日：" + data.birth),
        new Text("电话：" + data.phone),
        // new Text("密码：" + data.pwd),
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
