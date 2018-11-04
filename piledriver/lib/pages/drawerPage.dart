import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piledriver/pages/ProjectPage.dart';
import 'package:piledriver/pages/report/NewReport.dart';
import 'package:piledriver/pages/StuffPage.dart';
import 'package:piledriver/pages/Equipment.dart';
import 'package:piledriver/pages/SettingPage.dart';
import 'package:piledriver/pages/ReportPage.dart';
import 'package:piledriver/Utils/cache_util.dart';
import 'package:piledriver/common/constant.dart';

class DrawerPage extends StatefulWidget {
  @override
  createState() => new DrawerPageState();
}

class DrawerPageState extends State<DrawerPage> {
  Widget homeDrawer(context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(context),
      new ListTile(
        leading: new Icon(Icons.landscape),
        title: new Text('项目管理'),
        // subtitle: new Text("项目进度、施工纪录"),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new ProjectPage();
            },
          ), (route) => route == null);
        },
      ),
       new ListTile(
        leading: new Icon(Icons.view_agenda),
        title: new Text('设备管理'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new EquipmentPage();
            },
          ), (route) => route == null);
        },
      ),
      new ListTile(
        leading: new Icon(Icons.people),
        title: new Text('员工管理'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new StuffPage();
            },
          ), (route) => route == null);
        },
      ),
      new ListTile(
        leading: new Icon(Icons.pie_chart),
        title: new Text('统计报表'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new ReportPage();
            },
          ), (route) => route == null);
        },
      ),      new ListTile(
        leading: new Icon(Icons.edit),
        title: new Text('施工填报'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new NewReport();
            },
          ), (route) => route == null);
        },
      ),
      new ListTile(
        leading: new Icon(Icons.settings),
        title: new Text('设置'),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new SettingPage();
            },
          ), (route) => route == null);
        },
      ),
    ]);
  }

  static Widget _drawerHeader(context) {
    var imgname = "S${CacheUtil.getInstance().getUser().stuffID}";

    var src = Constant.baseUrl + "image/load/$imgname.jpg";
    return new DrawerHeader(
      padding: EdgeInsets.zero,
      /* padding置为0 */
      child: new Stack(children: <Widget>[
        /* 用stack来放背景图片 */
        new Image.asset(
          'static/images/drawbg.png',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        new Align(
          /* 先放置对齐 */
          alignment: FractionalOffset.bottomLeft,
          child: Container(
            height: 70.0,
            margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              /* 宽度只用包住子组件即可 */
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new CircleAvatar(
                  backgroundImage: new NetworkImage(src),
                  radius: 35.0,
                ),
                new Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                    mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                    children: <Widget>[
                      new Text(
                        "${CacheUtil.getInstance().getUser().name}",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      new Text(
                        "手机号码：${CacheUtil.getInstance().getUser().phone}",
                        style:
                            new TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white70,
      body: homeDrawer(context),
    );
  }
}
