import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:piledriver/common/style/GSYStyle.dart';
import 'package:piledriver/widget/GSYFlexButton.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:async/async.dart';

class NewProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewProjectPageState();
  }
}

class NewProjectPageState extends State<NewProjectPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();
  List<File> fileList = new List();
  Future<File> _imageFile;
  bool isLoading = false;
  String msg = "";
  String _projectName = '';
  String _projectDesc = '';
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
        _projectName = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        hintText: "请输入项目名称，不超过24个字",
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
        _projectDesc = str;
        setState(() {});
      },
      decoration: new InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: "请输入项目描述，不超过128个字",
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
        backgroundColor: Colors.blueGrey,
        body: new FutureBuilder(
          future: _imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null &&
                _imageFile != null) {
              // 选择了图片（拍照或图库选择），添加到List中
              fileList.add(snapshot.data);
              _imageFile = null;
            }
            // 返回的widget
            return getBody(context);
          },
        ),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    // 输入框

    // gridView用来显示选择的图片
    var gridView = new Builder(
      builder: (ctx) {
        return new GridView.count(
          // 分4列显示
          crossAxisCount: 5,
          children: new List.generate(fileList.length + 1, (index) {
            // 这个方法体用于生成GridView中的一个item
            var content;
            if (index == 0) {
              // 添加图片按钮
              var addCell = new Center(
                  child: new Image.asset(
                'static/images/add-image.png',
                width: 40.0,
                height: 40.0,
              ));
              content = new GestureDetector(
                onTap: () {
                  // 添加图片
                  pickImage(ctx);
                },
                child: addCell,
              );
            } else {
              // 被选中的图片
              content = new Center(
                  child: new Image.file(
                fileList[index - 1],
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              ));
            }
            return new Container(
              margin: const EdgeInsets.all(2.0),
              width: 40.0,
              height: 40.0,
              color: const Color(0xFFECECEC),
              child: content,
            );
          }),
        );
      },
    );
    var children = [
      new Padding(padding: new EdgeInsets.all(20.0)),
      new Text(
        "创建新的项目",
        style: new TextStyle(fontSize: 24.0),
      ),
      new Padding(padding: new EdgeInsets.all(20.0)),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "项目名称：",
            style: new TextStyle(fontSize: 14.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
      new Container(child: projectNameFiled()),
      new Padding(padding: new EdgeInsets.all(10.0)),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "项目描述：",
            style: new TextStyle(fontSize: 14.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
      new Container(height: 100.0, child: projectDescFiled()),
      new Padding(padding: new EdgeInsets.all(20.0)),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "添加项目图片(只能上传一张):",
            style: new TextStyle(fontSize: 14.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
      new Container(height: 100.0, child: gridView),
      new Padding(padding: new EdgeInsets.all(30.0)),
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
                Navigator.pop(context);
              },
            )
          ]),
    ];
    // if (isLoading) {
    //   children.add(new Container(
    //     margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
    //     child: new Center(
    //       child: new CircularProgressIndicator(),
    //     ),
    //   ));
    // } else {
    //   children.add(new Container(
    //       margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
    //       child: new Center(
    //         child: new Text(msg),
    //       )));
    // }

    return new Container(
      color: Colors.amber[200],
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

  // 相机拍照或者从图库选择图片
  pickImage(ctx) {
    // 如果已添加了1张图片，则提示不允许添加更多
    num size = fileList.length;
    if (size >= 1) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("最多只能添加1张图片！"),
      ));
      return;
    }
    showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return new Container(
        height: 182.0,
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
          child: new Column(
            children: <Widget>[
              _renderBottomMenuItem("相机拍照", ImageSource.camera),
              new Divider(
                height: 2.0,
              ),
              _renderBottomMenuItem("图库选择照片", ImageSource.gallery)
            ],
          ),
        ));
  }

  _renderBottomMenuItem(title, ImageSource source) {
    var item = new Container(
      height: 60.0,
      child: new Center(child: new Text(title)),
    );
    return new InkWell(
      child: item,
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          _imageFile = ImagePicker.pickImage(source: source);
        });
      },
    );
  }

  saveProject(ctx) async {
    // String name = userController.text;
    //     String desc = userController.text;

    if (_projectName == null || _projectName.length == 0 || _projectName.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入项目名称！"),
      ));
      return;
    }
    // 下面是调用接口发布动弹的逻辑
    try {
      Map<String, String> params = new Map();
      params['name'] = _projectName;
      params['desc'] = _projectDesc;
      // 构造一个MultipartRequest对象用于上传图片
      var request = new MultipartRequest(
          'POST', Uri.parse("http://127.0.0.1:8080/api/v1/project"));
      request.fields.addAll(params);
      if (fileList != null && fileList.length > 0) {
        // 这里虽然是添加了多个图片文件，但是开源中国提供的接口只接收一张图片
        for (File f in fileList) {
          // 文件流
          var stream =
              new http.ByteStream(DelegatingStream.typed(f.openRead()));
          // 文件长度
          var length = await f.length();
          // 文件名
          var filename = f.path.substring(f.path.lastIndexOf("/") + 1);
          // 将文件加入到请求体中
          request.files.add(new http.MultipartFile('img', stream, length,
              filename: filename));
        }
      }
      setState(() {
        isLoading = true;
      });
      // 发送请求
      var response = await request.send();
      // 解析请求返回的数据
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (value != null) {
          var obj = json.decode(value);
          var error = obj['error'];
          setState(() {
            if (error != null && error == '200') {
              // 成功
              setState(() {
                isLoading = false;
                msg = "发布成功";
                fileList.clear();
              });
            } else {
              setState(() {
                isLoading = false;
                msg = "发布失败：$error";
              });
            }
          });
        }
      });
    } catch (exception) {
      print(exception);
    }
  }
}
