import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:piledriver/bean/Equipment.dart';
import 'package:piledriver/bean/ProjectBean.dart';

import 'package:piledriver/pages/equipmentdetail/TabOne.dart';
import 'package:piledriver/pages/equipmentdetail/TabTwo.dart';


class EquipmentDetailPage extends StatefulWidget {
  final Equipment equipment;
  EquipmentDetailPage(this.equipment);

  @override
  EquipmentDetailPageState createState() => new EquipmentDetailPageState();
}

class EquipmentDetailPageState extends State<EquipmentDetailPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return buildBody(widget.equipment);
  }

  Widget buildBody(Equipment equipment) {
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
              child: Text( equipment.equipmentName+" 施工详情",
          )),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: "施工详情"),
              Tab(icon: Icon(Icons.credit_card), text: "设备详情"),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(child: TabOne(equipment)),
            new Center(child: TabTwo(equipment)),
          ],
        ),
      ),
    );
  }
}
