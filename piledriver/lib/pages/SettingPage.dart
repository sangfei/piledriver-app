import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:piledriver/pages/LoginPage.dart';
import 'package:piledriver/pages/ProjectPage.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final bindWebo = false;
  final bindWechat = false;
  final bindGitHub = false;

  Future<Null> _logOut() async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      await new File('$dir/LandingInformation').delete();
    } on FileSystemException {
      // 发生异常时返回默认值
      debugPrintStack();
      print("save exception");
    }
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new LoginPage();
      },
    ), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('设置'),
          leading: new IconButton(
            icon: new Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new ProjectPage();
                },
              ), (route) => route == null);
            },
          ),
          centerTitle: true,
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              child: new ListTile(
                title: new Text('手机'),
                onTap: () {},
                enabled: true,
                trailing: new Icon(Icons.keyboard_arrow_right),
              ),
              margin: const EdgeInsets.only(top: 20.0),
              decoration: const BoxDecoration(
                  border: const Border(
                top: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
            new Container(
              child: new ListTile(
                title: new Text('邮箱'),
                onTap: () {},
                enabled: true,
                trailing: new Icon(Icons.keyboard_arrow_right),
              ),
              decoration: const BoxDecoration(
                  border: const Border(
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
            new Container(
              child: new ListTile(
                title: new Text('修改账户密码'),
                onTap: () {},
                enabled: true,
                trailing: new Icon(Icons.keyboard_arrow_right),
              ),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: const BoxDecoration(
                  border: const Border(
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
            new Container(
              child: new SwitchListTile(
                value: bindWebo,
                onChanged: null,
                title: new Text('绑定微博'),
              ),
              decoration: const BoxDecoration(
                  border: const Border(
                top: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
            new Container(
              child: new SwitchListTile(
                title: new Text('绑定微信'),
                onChanged: null,
                value: bindWechat,
              ),
              decoration: const BoxDecoration(
                  border: const Border(
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
            new Container(
              child: new ListTile(
                title: new Center(child: new Text('退出账号')),
                onTap: () {
                  _logOut();
                },
                enabled: true,
              ),
              decoration: const BoxDecoration(
                  border: const Border(
                top: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xE3E3E3FF)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
