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
import 'package:piledriver/common/constant.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class NewStuffPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewStuffPageState();
  }
}

class NewStuffPageState extends State<NewStuffPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();
  List<File> fileList = new List();
  Future<File> _imageFile;
  int sexValue;
  int titleValue;
  bool isLoading = false;
  String msg = "";
  String _name = '';
  int _sex;
  String _birth = '请选择日期';
  int _title;
  String _phoneNum = '';

  final TextEditingController _namecontroller = new TextEditingController();
  final TextEditingController _phonecontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget radioFiled(param1, param2, int function) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Radio(
          value: 1,
          groupValue: function == 0 ? sexValue : titleValue,
          onChanged: (int e) => updateGroupValue(function, e),
        ),
        new Text(
          '$param1',
          style: new TextStyle(fontSize: 12.0),
        ),
        new Radio(
          value: 2,
          groupValue: function == 0 ? sexValue : titleValue,
          onChanged: (int e) => updateGroupValue(function, e),
        ),
        new Text(
          '$param2',
          style: new TextStyle(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  void updateGroupValue(int function, int e) {
    setState(() {
      if (function == 0) {
        _sex = e;
        sexValue = e;
      } else {
        _title = e;
        titleValue = e;
      }
    });
  }

  Widget nameFiled() {
    return new TextField(
      controller: _namecontroller,
      decoration: new InputDecoration(
        hintText: '姓名',
      ),
    );
  }

  Widget phoneFiled() {
    return new TextField(
      controller: _phonecontroller,
      decoration: new InputDecoration(
        hintText: '手机号',
      ),
    );
  }

  Widget stuffNameFiled() {
    var node = new FocusNode();
    return new TextField(
      style: new TextStyle(color: Colors.black, fontSize: 16.00),
      onChanged: (str) {
        _name = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        hintText: "请输入姓名",
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
       new Text(
        "增加新员工",
        style: new TextStyle(fontSize: 24.0),
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(
            "姓名:",
            style: new TextStyle(fontSize: 16.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
          new Flexible(child: nameFiled()),
        ],
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(
            "手机:",
            style: new TextStyle(fontSize: 16.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
          new Flexible(child: phoneFiled()),
        ],
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "职务:",
            style: new TextStyle(fontSize: 16.0),
          ),
          // Padding(padding: new EdgeInsets.only(left: 20.0)),
          new Flexible(child: radioFiled('技术员', '组长', 1)),
        ],
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "性别:",
            style: new TextStyle(fontSize: 16.0),
          ),
          // Padding(padding: new EdgeInsets.only(left: 20.0)),
          new Flexible(child: radioFiled('男', '女', 0)),
        ],
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "生日:",
            style: new TextStyle(fontSize: 16.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
          new FlatButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    onChanged: (date) {}, onConfirm: (date) {
                  setState(() {
                    _birth = DateFormat('yyyy-MM-dd').format(date);
                  });
                }, currentTime: DateTime(2008, 12, 31), locale: 'zh');
              },
              child: Text(
                '$_birth',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
       new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "添加头像(只能上传一张):",
            style: new TextStyle(fontSize: 16.0),
          ),
          Padding(padding: new EdgeInsets.only(left: 20.0)),
        ],
      ),
       new Divider(height: 5.0, color: Colors.black),
      new Container(height: 100.0, child: gridView),
      new Padding(padding: new EdgeInsets.all(10.0)),
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
    _name = _namecontroller.text;
    _phoneNum = _phonecontroller.text;

    if (_name == null || _name.length == 0 || _name.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入姓名！"),
      ));
      return;
    }

    if (_phoneNum == null ||
        _phoneNum.length == 0 ||
        _phoneNum.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("手机号代表你的唯一编码！"),
      ));
      return;
    }

    if (_title == null) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择职务！"),
      ));
      return;
    }

    if (_sex == null) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择性别！"),
      ));
      return;
    }

    if (_birth == '请选择日期') {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择日期！"),
      ));
      return;
    }

    if (fileList.length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择头像！"),
      ));
      return;
    }
    // 下面是调用接口
    try {
      Map<String, String> params = new Map();
      params['phone'] = _phoneNum;
      params['name'] = _name;
      params['sex'] = _sex == 1 ? '男' : '女';
      params['title'] = _title == 1 ? '1' : '2';
      params['birth'] = _birth;
      // 构造一个MultipartRequest对象用于上传图片
      var request = new MultipartRequest(
          'POST', Uri.parse(Constant.baseUrl + "api/v1/stuff"));
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
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          msg = "发布成功";
          fileList.clear();
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
                  msg = "电话号码重复";
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
