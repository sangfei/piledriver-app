import 'package:flutter/material.dart';
import 'package:piledriver/pages/project/TabOne.dart';
import 'package:piledriver/pages/drawerPage.dart';
import 'package:piledriver/pages/project/NewProjectPage.dart';

/**
 * 主页
 */
class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectPageState();
  }
}

class ProjectPageState extends State<ProjectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //为给定的[子]控件创建默认选项卡控制器。
    return new Scaffold(
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
                  tooltip: '新增项目',
                  onPressed: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new NewProjectPage();
                    }));
                  }),
              new Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Theme.of(context).primaryColor),
                  child: new PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                            new PopupMenuItem<String>(
                                value: "name", child: new Text('按项目名称排序')),
                            new PopupMenuItem<String>(
                                value: "time", child: new Text('按项目创建时间排序')),
                          ],
                      onSelected: (String action) {
                        switch (action) {
                          case "name":
                            // do nothing
                            break;
                          case "time":
                            // do nothing
                            break;
                        }
                      })),
            ],

            backgroundColor: Colors.lightBlueAccent,
            // title: titleWidget(),
            title: new Text(
              "项目列表",
              style: new TextStyle(color: Colors.black, fontSize: 16.00),
            ),
          ),
          preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.028 < 68.0
                  ? 68.0
                  : MediaQuery.of(context).size.height * 0.028)),
      body: new TabOne(),
    );
  }
}
