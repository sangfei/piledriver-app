import 'package:flutter/material.dart';
import 'package:piledriver/pages/stuff/TabOne.dart';

/**
 * 主页
 */
class StuffListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StuffListPageState();
  }
}

class StuffListPageState extends State<StuffListPage> {
  @override
  Widget build(BuildContext context) {
    //为给定的[子]控件创建默认选项卡控制器。
    return new DefaultTabController(
        length: 5,
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.black45,
           // title: titleWidget(),
            title: new Text("人员管理",style: new TextStyle(color: Colors.white,fontSize: 22.00),),
            bottom: new TabBar(
                isScrollable: true,
                labelStyle: new TextStyle(fontSize: 22.00,color: Colors.red),
                indicatorPadding:EdgeInsets.zero,
                labelColor: Colors.white,
                indicatorWeight:4.0,
                unselectedLabelColor: Colors.blueAccent,
                tabs: [
                  new Tab(
                    text: "员工列表",
                  ),
                ]),
          ),
          body: new TabBarView(children: [new TabOne()]),
        ));
  }
}
