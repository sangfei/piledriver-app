import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:piledriver/common/style/GSYStyle.dart';
import 'package:piledriver/widget/GSYFlexButton.dart';
import 'package:http/http.dart';
import 'package:async/async.dart';
import 'package:piledriver/common/constant.dart';
import 'package:piledriver/pages/ProjectPage.dart';
import 'package:piledriver/bean/ProjectBean.dart';
import 'package:piledriver/pages/WorkRegion.dart';

class NewWorkregionPage extends StatefulWidget {
  final ProjectBean project;

  NewWorkregionPage(this.project);
  @override
  State<StatefulWidget> createState() {
    return new NewWorkregionPageState();
  }
}

class NewWorkregionPageState extends State<NewWorkregionPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  bool isLoading = false;
  String msg = "";
  String _workregionName = '';
  String _workeregionDesc = '';
  // final TextEditingController userController = new TextEditingController();
  // final TextEditingController pwController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget projectNameFiled() {
    var node = new FocusNode();
    return new TextField(
      style: new TextStyle(color: Colors.black, fontSize: 16.00),
      onChanged: (str) {
        _workregionName = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        hintText: "请输入地块名称",
        hintStyle:
            new TextStyle(color: const Color(0xFF808080), fontSize: 12.00),
        // border: new OutlineInputBorder(
        //   gapPadding: 10.0,
        //     borderRadius:
        //         const BorderRadius.all(const Radius.circular(5.0)))
      ),
      maxLines: 1,
      maxLength: 24,
      obscureText: false,
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );
  }

  Widget projectDescFiled() {
    var node = new FocusNode();
    return new TextField(
      style: new TextStyle(color: Colors.black, fontSize: 16.00),
      onChanged: (str) {
        _workeregionDesc = str;
        setState(() {});
      },
      decoration: new InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: "请输入地块描述，不超过128个字",
          hintStyle:
              new TextStyle(color: const Color(0xFF808080), fontSize: 12.00),
          border: new OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(5.0)))),
      maxLines: 8,
      maxLength: 128,
      obscureText: false,
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );
  }

  showTips() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text('用户名或密码错误',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 24.0))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
          key: registKey,
          backgroundColor: Colors.lightBlueAccent,
          body: getBody(context)),
    );
  }

  Widget getBody(BuildContext context) {
    // 输入框

    // gridView用来显示选择的图片

    var children = [
      new Text(
        "为${widget.project.projectName}创建新的地块",
        style: new TextStyle(fontSize: 24.0),
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "地块名称：",
            style: new TextStyle(fontSize: 14.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
      new Container(child: projectNameFiled()),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "地块描述：",
            style: new TextStyle(fontSize: 14.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
      new Container(height: 100.0, child: projectDescFiled()),
      Padding(padding: new EdgeInsets.only(bottom: 20.0)),
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new GSYFlexButton(
              text: "保存",
              color: Colors.red,
              textColor: Color(GSYColors.textWhite),
              onPress: () {
                saveProject(context);
              },
            ),
            new Padding(padding: new EdgeInsets.all(20.0)),
            new GSYFlexButton(
              text: "取消",
              color: Colors.grey,
              textColor: Color(GSYColors.textWhite),
              onPress: () {
                Navigator.pushAndRemoveUntil(context,
                    new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new WorkRegionPage(widget.project);
                  },
                ), (route) => route == null);
              },
            )
          ]),
    ];
    if (isLoading) {
      children.add(new Container(
        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      ));
    } else {
      children.add(new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Center(
            child: new Text(msg),
          )));
    }

    return new Container(
      color: Colors.lightBlueAccent,
      child: new Center(
          child: new Card(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Colors.white,
              margin: const EdgeInsets.all(10.0),
              child: new Padding(
                  padding: new EdgeInsets.only(
                      left: 30.0, top: 10.0, right: 30.0, bottom: 20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  )))),
    );
  }

  saveProject(ctx) async {
    // String name = userController.text;
    //     String desc = userController.text;

    if (_workregionName == null ||
        _workregionName.length == 0 ||
        _workregionName.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入地块名称！"),
      ));
      return;
    }

    // 下面是调用接口发布动弹的逻辑
    try {
      Map<String, String> params = new Map();
      params['name'] = _workregionName;
      params['desc'] = _workeregionDesc;
      params['projectid'] = widget.project.projectID.toString();

      // 构造一个MultipartRequest对象用于上传图片
      var request = new MultipartRequest(
          'POST', Uri.parse(Constant.baseUrl + "api/v1/workregion"));
      request.fields.addAll(params);

      setState(() {
        isLoading = true;
      });
      // 发送请求
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          msg = "发布成功";
        });
      } else {
        // 解析请求返回的数据
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
          if (value != null) {
            var obj = json.decode(value);
            print(obj);
            setState(() {
              if (obj == -2) {
                // 成功
                setState(() {
                  isLoading = false;
                  msg = "地块名称重复";
                });
              } else {
                setState(() {
                  isLoading = false;
                  msg = "保存失败";
                });
              }
            });
          }
        });
      }
    } catch (exception) {
      print(exception);
    }
  }
}
