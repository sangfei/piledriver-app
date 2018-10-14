import 'package:flutter/material.dart';
import 'package:piledriver/pages/equipment/TabOne.dart';
import 'package:piledriver/pages/equipment/NewEquipment1.dart';
import 'package:piledriver/pages/drawerPage.dart';

/**
 * 主页
 */
class EquipmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EquipmentPageState();
  }
}

class EquipmentPageState extends State<EquipmentPage> {
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
                  icon: new Icon(Icons.add_circle),
                  color: Colors.black,
                  tooltip: '新增设备',
                  onPressed: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new TabOne1();
                    }));
                  }),
              new Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Theme.of(context).primaryColor),
                  child: new PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                            new PopupMenuItem<String>(
                                value: "name", child: new Text('按名称排序')),
                            new PopupMenuItem<String>(
                                value: "time", child: new Text('按设备类型排序')),
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
              "设备列表",
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
