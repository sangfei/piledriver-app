import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:piledriver/bean/projectBean.dart';
import 'package:http/http.dart' as http;
import 'package:piledriver/common/constant.dart';
import 'package:piledriver/pages/workregion/TabOne.dart';

class WorkRegionPage extends StatefulWidget {
  final ProjectBean projectInfo;

  WorkRegionPage(this.projectInfo);

  @override
  WorkRegionPageState createState() => new WorkRegionPageState();
}

class WorkRegionPageState extends State<WorkRegionPage>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    ProjectBean project = widget.projectInfo;

    return buildBody(project);
  }

  Widget buildBody(ProjectBean project) {
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
          backgroundColor: Colors.amber[200],
          title: new Container(
              child: Text(
            project.projectName,
          )),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: "施工地块"),
              Tab(icon: Icon(Icons.credit_card), text: "项目详情"),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(child: TabOne(project)),
            new Center(child: new Text('船')),
          ],
        ),
      ),
    );
  }
}
