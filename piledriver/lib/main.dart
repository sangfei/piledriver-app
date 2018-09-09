import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'pages/index.dart';
import 'pages/login.dart';

void main() {
  _getLandingFile().then((onValue) {
    runApp(new MyApp(onValue.existsSync()));
  });
}

Future<File> _getLandingFile() async {
  try {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/LandingInformation');
  } on FileSystemException {
    print('============exception');
    return null;
  }
}

class MyApp extends StatelessWidget {
  MyApp(this.landing);
  final bool landing;

  @override
  Widget build(BuildContext context) {
    print('============>$landing');
    return new MaterialApp(
        title: '桩机施工管理',
        theme: new ThemeData(
            highlightColor: Colors.transparent, //将点击高亮色设为透明
            splashColor: Colors.transparent, //将喷溅颜色设为透明
            bottomAppBarColor:
                new Color.fromRGBO(244, 245, 245, 0.5), //设置底部导航的背景色
            scaffoldBackgroundColor:
                new Color.fromRGBO(244, 245, 245, 1.0), //设置页面背景颜色
            primaryIconTheme:
                new IconThemeData(color: Colors.red), //主要icon样式，如头部返回icon按钮
            indicatorColor: Colors.blue, //设置tab指示器颜色
            iconTheme: new IconThemeData(size: 18.0), //设置icon样式
            primaryTextTheme: new TextTheme(
                //设置文本样式
                // display1: new TextStyle(color: Colors.deepPurple, fontSize:12.0),
                title: new TextStyle(color: Colors.black, fontSize: 16.0))),
        home: landing ? new IndexPage() : new LoginPage(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/index': (BuildContext context) => IndexPage(),
        });
  }
}
