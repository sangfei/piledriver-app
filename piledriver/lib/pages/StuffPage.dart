import 'package:flutter/material.dart';
import 'package:piledriver/pages/stuff/TabOne.dart';
import 'package:piledriver/pages/drawerPage.dart';
import 'package:piledriver/pages/stuff/NewStuffPage.dart';

/**
 * 主页
 */
class StuffPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StuffPageState();
  }
}

class StuffPageState extends State<StuffPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
     //为给定的[子]控件创建默认选项卡控制器。
    return new DefaultTabController(
        length: 1,
        child: new Scaffold(
          key: _scaffoldKey,
          drawer: new Drawer(
            child: new DrawerPage(),
          ),
          appBar: PreferredSize(
              child: AppBar(
                leading: new IconButton(
                    icon: new Icon(
                      Icons.list,
                      color: Colors.black,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openDrawer()),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.search),
                      color: Colors.black,
                      tooltip: '查找项目',
                      onPressed: () {
                        // do nothing
                      }),
                  new IconButton(
                      icon: new Icon(Icons.add_circle),
                      color: Colors.black,
                      tooltip: '新增员工',
                      onPressed: () {
                        Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return new NewStuffPage();
                        }));
                      }),
                ],

                backgroundColor: Colors.amber[200],
                // title: titleWidget(),
                title: new Text(
                  "员工列表",
                  style: new TextStyle(color: Colors.black, fontSize: 16.00),
                ),
              ),
              preferredSize: Size.fromHeight(
                  MediaQuery.of(context).size.height * 0.028 < 68.0
                      ? 68.0
                      : MediaQuery.of(context).size.height * 0.028)),
          body: new TabBarView(children: [new TabOne()]),
        ));
  }
}
