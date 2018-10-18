import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:piledriver/bean/Equipment.dart';
import 'package:flutter/cupertino.dart';
import 'package:piledriver/pages/Equipment.dart';
import 'package:piledriver/common/style/GSYStyle.dart';
import 'package:piledriver/widget/GSYFlexButton.dart';
import 'package:piledriver/pages/WorkRegion.dart';

class TabTwo extends StatefulWidget {
  final Equipment equipment;
  TabTwo(this.equipment);
 
  @override
  State<StatefulWidget> createState() {
    return new TabTwoState();
  }
}

class TabTwoState extends State<TabTwo> {
  @override
  void initState() {
    super.initState();
  }

  void deleteProject() {
    getApiData().then((value) {
      print(value);
      if (0 == value) {
        // 清除导航纪录
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new EquipmentPage();
          },
        ), (route) => route == null);
      } else {
        showTips();
      }
    });
  }

  showTips() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text('删除失败',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 24.0))));
        });
  }

  Future<bool> deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('确定要删除此设备吗?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(0.0),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new GSYFlexButton(
                  text: "删除",
                  color: Colors.red,
                  textColor: Color(GSYColors.textWhite),
                  onPress: () {
                    deleteDialog(context).then((value) {
                      print('Value is $value');
                      if (value) {
                        deleteProject();
                      }
                    });
                  },
                ),
              ]),
        ]));
  }

  Future getApiData() async {
    var url =
        Constant.baseUrl + '/api/v1/equipment?id=${widget.equipment.equipmentid}';
    var httpClient = new HttpClient();
    var request = await httpClient.deleteUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }
}
