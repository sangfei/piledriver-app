import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import './constructionDetail.dart';
import 'package:http/http.dart' as http;

class ProjectDetail extends StatefulWidget {
  final Map projectInfo;

  @override
  ProjectDetail({Key key, this.projectInfo}) : super(key: key);

  @override
  ProjectDetailState createState() => new ProjectDetailState();
}


class ProjectDetailState extends State<ProjectDetail> {
//  获取projectlist
  Future getProjects() async {
    print('============');
    print(widget.projectInfo);
    final response = await http.get('http://49.4.54.72:32500/api/v1/workregion?projectid=${widget
        .projectInfo['machineId']}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    var project = widget.projectInfo;
    return FutureBuilder(
      future: getProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot is :${snapshot.data[0]}');
          return new Scaffold(
            appBar: new CupertinoNavigationBar(
              backgroundColor: Colors.blue,
              middle: new Text(
                project['name'],
                style: new TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            body: _buildSuggestions(snapshot.data),
          );
        } else if (snapshot.hasError) {
          return Text("error1>>>>>>>>>>>>>>>:${snapshot.error}");
        }
        return new Container(
          color: new Color.fromRGBO(244, 245, 245, 1.0),
        );
      },
    );
  }

  //定义一个子控件，这个控件就是放置随机字符串词组的列表
  Widget _buildSuggestions(projectList) {
    return new ListView.builder(
        itemCount: projectList.length,
        //ListView(列表视图)是material.dart中的基础控件
        padding: const EdgeInsets.all(1.0), //padding(内边距)是ListView的属性，配置其属性值
        //通过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
        //此函数会自动循环并计数，咋结束的我也不知道，走着瞧咯
        itemBuilder: (context, i) {
          print(i);
          var item = projectList[i];
          print(item);
          return _buildRow(item); //把这个数据项塞入ListView中
        });
  }

  //定义的_suggestions数组项属性
  Widget _buildRow(item) {
    return new Container(
      child: new ListTile(
        leading: new Icon(
          Icons.flag,
          color: Colors.orange,
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        title: new Text(item['name']),
        onTap: () {
          Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) => ConstructionDetail(workRegion: item)));
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
