import 'package:flutter/material.dart';
import 'package:piledriver/pages/report/Tab1.dart';
import 'package:piledriver/pages/report/Tab2.dart';
import 'package:piledriver/pages/report/Tab3.dart';
import 'package:piledriver/pages/report/Tab4.dart';
import 'package:piledriver/pages/drawerPage.dart';

/**
 * 主页
 */
class ReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        key: _scaffoldKey,
        drawer: new Drawer(
          child: new DrawerPage(),
        ),
        appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          backgroundColor: Color.fromRGBO(56, 122, 234, 1.0),
          title: new Container(
              child: Text(
            "统计报表", style: new TextStyle(color:Colors.white),
          )),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromRGBO(128, 168, 235, 1.0),
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: "按项目统计"),
              Tab(icon: Icon(Icons.credit_card), text: "按地块统计"),
              Tab(icon: Icon(Icons.view_agenda), text: "按设备统计"),
              Tab(icon: Icon(Icons.people), text: "按员工统计"),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(child: TabOne()),
            new Center(child: TabTwo()),
            new Center(child: TabThree()),
            new Center(child: TabFour()),
          ],
        ),
      ),
    );
  }
}
