import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/bean/ProjectBean.dart';

import 'package:piledriver/pages/construction/TabOne.dart';
import 'package:piledriver/pages/construction/TabTwo.dart';


class ConstructionPage extends StatefulWidget {
  final WorkRegionBean workRegion;
  final ProjectBean project;
  ConstructionPage(this.workRegion, this.project);

  @override
  ConstructionPageState createState() => new ConstructionPageState();
}

class ConstructionPageState extends State<ConstructionPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return buildBody(widget.workRegion,widget.project);
  }

  Widget buildBody(WorkRegionBean workRegion, ProjectBean project) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        // backgroundColor: Colors.white,
        appBar: new AppBar(
          //  iconTheme: IconThemeData(
          //   color: Colors.white, //change your color here
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
            backgroundColor: Colors.lightBlueAccent,
          title: new Container(
              child: Text(
            project.projectName + ":" + workRegion.name+" 施工详情",
          )),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: "施工详情"),
              Tab(icon: Icon(Icons.credit_card), text: "地块详情"),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(child: TabOne(workRegion)),
            new Center(child: TabTwo(workRegion, project)),
          ],
        ),
      ),
    );
  }
}
