import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/StuffBean.dart';
import 'package:piledriver/common/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class TabOne1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabOneState();
  }
}

class TabOneState extends State<TabOne1> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  List<StuffBean> datas = [];
  var selectItemValue;
  bool isLoading = false;
  String msg = "";
  File _image;
  String equipmentName;
  String equipmentBrand;
  String equipmentModel;
  String equipmentDiameter;
  String ownerid;

  List<TextEditingController> controllers = new List();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController brandController = new TextEditingController();
  final TextEditingController modelController = new TextEditingController();
  final TextEditingController diameterController = new TextEditingController();

  var items = ['设备名称：', '设备品牌：', '设备型号：', '成孔直径：'];

  void generateControllersList() {
    controllers.add(nameController);
    controllers.add(brandController);
    controllers.add(modelController);
    controllers.add(diameterController);
  }

  List<DropdownMenuItem> generateItemList() {
    List<DropdownMenuItem> items = new List();

    for (int i = 0; i < datas.length; i++) {
      StuffBean data = datas[i];
      DropdownMenuItem item1 =
          new DropdownMenuItem(value: data.stuffID, child: new Text(data.name));
      items.add(item1);
    }
    return items;
  }

  bool loading = true;
  @override
  void initState() {
    super.initState();
    generateControllersList();
    getApiData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        key: registKey,
        // backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(title: Text('增加新设备')),
        body: new FutureBuilder(
          // future: _imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            return buildBody(context);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    var content;
    var scrollController = ScrollController();
    if (datas.isEmpty) {
      if (loading) {
        content = new Center(
          child: new CircularProgressIndicator(),
        );
      } else {
        content = new Center(
          child: new Text('没有数据'),
        );
      }
    } else {
      content = ListView(
        children: buildProjectItems(context),
        controller: scrollController,
      );
    }

    return content;
  }

  Future getApiData() async {
    //当前的项目列表
    var url = Constant.baseUrl + "/api/v1/list/stuff";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        datas = StuffBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  // 每个条目的信息
  buildProjectItems(context) {
    final widthfull = MediaQuery.of(context).size.width;

    List<Widget> widgets = [];
    widgets.add(new Padding(
      padding: const EdgeInsets.all(10.0),
    ));
    for (int i = 0; i < items.length; i++) {
      var gd = new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Expanded(
            child: new Container(
              height: 70.0,
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              // decoration: new BoxDecoration(
              //   color: Color.fromRGBO(0, 0, 0, 0.05),
              //   border: new Border(bottom: new BorderSide(color: Colors.black)),
              // ),
              child: new Padding(
                padding: const EdgeInsets.all(1.0),
                child: new TextField(
                  controller: controllers[i],
                  // enabled: !snapshot.data,
                  style: new TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: new InputDecoration(
                      // hintText: '请输入手机号',
                      labelText: items[i],
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15.0),
                      hintStyle: TextStyle(fontSize: 14.0)),
                ),
              ),
            ),
          )
        ],
      );
      widgets.add(gd);
    }
    var dropdown = new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: new Container(
            height: 70.0,
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            // decoration: new BoxDecoration(
            //   color: Color.fromRGBO(0, 0, 0, 0.05),
            //   border: new Border(bottom: new BorderSide(color: Colors.black)),
            // ),
            child: new Row(children: <Widget>[
              SizedBox(
                width: widthfull * 0.3,
                // height: 40.0,
                child: new Text(
                  "负责人：",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0),
                ),
              ),
              SizedBox(
                width: widthfull * 0.7 - 40,
                height: 40.0,
                child: new DropdownButton(
                  hint: new Text(
                    "请选择负责人",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
                  ),
                  value: selectItemValue,
                  items: generateItemList(),
                  onChanged: (T) {
                    setState(() {
                      selectItemValue = T;
                    });
                  },
                ),
              ),
            ]),
          ),
        )
      ],
    );

    widgets.add(dropdown);
    var img = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          child: new Container(
            height: 70.0,
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: new Row(children: <Widget>[
              SizedBox(
                width: widthfull * 0.3,
                // height: 40.0,
                child: new Text(
                  "设备照片：",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: new GestureDetector(
                  onTap: () {
                    // 添加图片
                    getImage();
                  },
                  child: new Center(
                      child: _image == null
                          ? new Text('点我选择照片')
                          : new CircleAvatar(
                              backgroundImage: new FileImage(_image),
                              radius: 50.0,
                            )),
                ),
              )
            ]),
          ),
        )
      ],
    );

    widgets.add(img);
    var btn = Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Material(
          //带给我们Material的美丽风格美滋滋。你也多看看这个布局
          elevation: 10.0,
          color: Colors.transparent,
          shape: const StadiumBorder(),
          child: InkWell(
            onTap: () {
               saveProject(context);
              // _Login(this._userPhone, this._passWold, context);
            },
            //来个飞溅美滋滋。
            splashColor: Colors.purpleAccent,
            child: Ink(
              height: 40.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[Color(0xFF4DD0E1), Color(0xFF00838F)],
              )),
              child: Center(
                child: Text(
                  '保存',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0),
                ),
              ),
            ),
          ),
        ));

    widgets.add(btn);

    if (isLoading) {
      widgets.add(new Container(
        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      ));
    } else {
      widgets.add(new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Center(
            child: new Text(msg),
          )));
    }

    return widgets;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  saveProject(ctx) async {
    equipmentName = nameController.text;
    equipmentBrand = brandController.text;
    equipmentModel = modelController.text;
    equipmentDiameter = diameterController.text;
    ownerid = selectItemValue.toString();
    if (equipmentName == null ||
        equipmentName.length == 0 ||
        equipmentName.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入名称"),
      ));
      return;
    }
    if (ownerid == 'null' ||
        ownerid.length == 0 ||
        ownerid.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入负责人！"),
      ));
      return;
    }
    if (_image == null) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择图片！"),
      ));
      return;
    }
    // 下面是调用接口发布动弹的逻辑
    try {
      Map<String, String> params = new Map();
      params['name'] = equipmentName;
      params['brand'] = equipmentBrand;
      params['model'] = equipmentModel;
      params['diameter'] = equipmentDiameter;
      params['ownerid'] = ownerid;
      // 构造一个MultipartRequest对象用于上传图片
      var request = new MultipartRequest(
          'POST', Uri.parse(Constant.baseUrl + "api/v1/equipment"));
      request.fields.addAll(params);

      // 文件流
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // 文件长度
      var length = await _image.length();
      // 文件名
      var filename = _image.path.substring(_image.path.lastIndexOf("/") + 1);
      // 将文件加入到请求体中
      request.files.add(
          new http.MultipartFile('img', stream, length, filename: filename));

      setState(() {
        isLoading = true;
      });
      // 发送请求
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          msg = "发布成功";
          _image = null;
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
                  msg = "名称重复";
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
