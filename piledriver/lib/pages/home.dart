import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import './projectDetail.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
//  获取projectlist
  Future getProjects() async {
    final response = await http.get('http://49.4.54.72:32500/api/v1/project');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot is :${snapshot.data[0]}');

          return new Scaffold(
            appBar: new CupertinoNavigationBar(
              backgroundColor: Colors.blue,
              middle: new Text(
                '项目列表',
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
          Icons.language,
          color: Colors.orange,
        ),
        title: new Text(item['name']),
        enabled: true,
        trailing: new Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) => ProjectDetail(projectInfo: item)));
        },
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
