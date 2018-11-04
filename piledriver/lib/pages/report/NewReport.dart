import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piledriver/bean/StuffBean.dart';
import 'package:piledriver/bean/ProjectBean.dart';
import 'package:piledriver/bean/Equipment.dart';
import 'package:piledriver/bean/WorkRegionBean.dart';
import 'package:piledriver/pages/DrawerPage.dart';
import 'package:piledriver/common/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class NewReport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewReportState();
  }
}

class NewReportState extends State<NewReport> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<ProjectBean> projectList = [];
  List<Equipment> equipmentList = [];
  List<StuffBean> stuffList = [];
  List<WorkRegionBean> workRegionList = [];

  SelectedItem selectProjectItem = new SelectedItem();
  SelectedItem selectWorkRegionItem = new SelectedItem();
  SelectedItem selectEquipmentItem = new SelectedItem();
  SelectedItem selectStuffItem = new SelectedItem();

  bool isLoading = false;
  String msg = "";
  File _image;
  String pieces;
  String ownerid;
  DateTime dateUtc = DateTime.now();
  String datestr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<TextEditingController> controllers = new List();
  final TextEditingController piecesController = new TextEditingController();

  var items = ['成桩数量：'];

  bool loading = true;
  @override
  void initState() {
    super.initState();
    generateControllersList();
    getStuffList();
    getEquipmentList();
    getProjectList();
    getWorkRegionList();
  }

  void generateControllersList() {
    controllers.add(piecesController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        key: _scaffoldKey,
        drawer: new Drawer(
          child: new DrawerPage(),
        ),
        // backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
            title: Text('施工数据上报'),
            leading: new IconButton(
                icon: new Icon(
                  Icons.list,
                  color: Colors.black,
                ),
                onPressed: () => _scaffoldKey.currentState.openDrawer())),
        body: new FutureBuilder(
          // future: _imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            return buildBody(context);
          },
        ),
      ),
    );
  }

  //下拉菜单中的内容
  List<DropdownMenuItem> generateItemList(list) {
    List<DropdownMenuItem> items = new List();

    for (int i = 0; i < list.length; i++) {
      var obj = list[i];
      if (obj is StuffBean) {
        StuffBean data = obj;
        DropdownMenuItem item1 = new DropdownMenuItem(
            value: data.stuffID, child: new Text(data.name));
        items.add(item1);
      } else if (obj is Equipment) {
        Equipment data = obj;
        DropdownMenuItem item1 = new DropdownMenuItem(
            value: data.equipmentid, child: new Text(data.equipmentName));
        items.add(item1);
      } else if (obj is ProjectBean) {
        ProjectBean data = obj;
        DropdownMenuItem item1 = new DropdownMenuItem(
            value: data.projectID,
            child: new Text(data.partya + '-' + data.projectName));
        items.add(item1);
      } else if (obj is WorkRegionBean) {
        WorkRegionBean data = obj;
        DropdownMenuItem item1 =
            new DropdownMenuItem(value: data.id, child: new Text(data.name));
        items.add(item1);
      }
    }
    return items;
  }

  Widget buildBody(BuildContext context) {
    var content;
    var scrollController = ScrollController();
    if (stuffList.isEmpty) {
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

  Future getWorkRegionList() async {
    var url = Constant.baseUrl + '/api/v1/workregion';
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        workRegionList = WorkRegionBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  Future getEquipmentList() async {
    //当前的项目列表
    var url = Constant.baseUrl + "/api/v1/list/equipment";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        equipmentList = Equipment.decodeData(jsonData);
        loading = false;
      });
    }
  }

  Future getProjectList() async {
    //当前的项目列表
    var url = Constant.baseUrl + "/api/v1/project";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        projectList = ProjectBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  Future getStuffList() async {
    //当前的项目列表
    var url = Constant.baseUrl + "/api/v1/list/stuff";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        stuffList = StuffBean.decodeData(jsonData);
        loading = false;
      });
    }
  }

  Widget _buildDateField() {
    return ListTile(
      leading: Container(
          width: 80.0,
          child: new Text(
            '日期：',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 15.0),
          )),
      title: new Align(
        alignment: Alignment.centerLeft,
        child: new FlatButton(
          onPressed: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                onChanged: (date) {}, onConfirm: (date) {
              setState(() {
                dateUtc = date;
                datestr = DateFormat('yyyy-MM-dd').format(date);
              });
            }, currentTime: DateTime.now(), locale: 'zh');
          },
          child: Text(
            '$datestr',
            style: TextStyle(color: Colors.blue),
          )),
      ) 
    );
  }

  Widget _bildDropDown(itemkey, hitText, dataList, SelectedItem select) {
    return ListTile(
      leading: Container(
          width: 80.0,
          child: new Text(
            itemkey,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 15.0),
          )),
      title: Container(
        child: new DropdownButton(
          hint: new Text(
            hitText,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
          ),
          value: select.value == 0 ? null : select.value,
          items: generateItemList(dataList),
          onChanged: (T) {
            setState(() {
              print(T.toString());
              select.value = T;
            });
          },
        ),
      ),
    );
  }

  Widget _bildTextField(itemkey, hitText, i) {
    return ListTile(
      leading: Container(
          width: 80.0,
          child: new Text(
            itemkey,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 15.0),
          )),
      title: Container(
        child: new TextField(
          keyboardType: TextInputType.number,
          controller: controllers[i],
          style: new TextStyle(fontSize: 16.0, color: Colors.black),
          decoration: new InputDecoration(
              // labelText: "ssss",
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
              hintStyle: TextStyle(fontSize: 14.0)),
        ),
      ),
    );
  }

  // 每个���目的信息
  buildProjectItems(context) {
    final widthfull = MediaQuery.of(context).size.width;

    List<Widget> widgets = [];
    widgets.add(_buildDateField());
    widgets.add(_bildDropDown('项目：', '选择项目', projectList, selectProjectItem));
    widgets.add(
        _bildDropDown('地块：', '选择地块', workRegionList, selectWorkRegionItem));
    widgets
        .add(_bildDropDown('设备：', '选择设备', equipmentList, selectEquipmentItem));
    widgets.add(_bildDropDown('负责人：', '选择负责人', stuffList, selectStuffItem));
    // widgets.add(_bildDropDown('生产状态：', '正常', stuffList));

    widgets.add(new Padding(
      padding: const EdgeInsets.all(10.0),
    ));
    for (int i = 0; i < items.length; i++) {
      widgets.add(_bildTextField(items[i], '', i));
    }
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
                  "异常详情图片：",
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
                          ? new Text('点我择照片')
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
    pieces = piecesController.text;

    if (pieces == null || pieces.length == 0 || pieces.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入名称"),
      ));
      return;
    }

    if (selectProjectItem.value == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择项目！"),
      ));
      return;
    }

    if (selectWorkRegionItem.value == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择地块！"),
      ));
      return;
    }

    if (selectEquipmentItem.value == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择设备！"),
      ));
      return;
    }

    if (selectStuffItem.value == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请选择负责人！"),
      ));
      return;
    }

    // if (_image == null) {
    //   Scaffold.of(ctx).showSnackBar(new SnackBar(
    //     content: new Text("请选择图片！"),
    //   ));
    //   return;
    // }

    try {
      Map<String, String> params = new Map();
      params['date'] = DateTime.parse(DateFormat('yyyy-MM-dd').format(dateUtc))
          .millisecondsSinceEpoch
          .toString();
      params['pieces'] = pieces;

      params['projectid'] = selectProjectItem.value.toString();
      params['workregion'] = selectWorkRegionItem.value.toString();
      params['equipmentid'] = selectEquipmentItem.value.toString();
      params['ownerid'] = selectStuffItem.value.toString();

      // 构造一个MultipartRequest对象用于上传图片
      var request = new MultipartRequest(
          'POST', Uri.parse(Constant.baseUrl + "api/v1/construction"));
      request.fields.addAll(params);

      // // 文件流
      // var stream =
      //     new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // // 文件长度
      // var length = await _image.length();
      // // 文件名
      // var filename = _image.path.substring(_image.path.lastIndexOf("/") + 1);
      // // 将文��加入到请求体中
      // request.files.add(
      //     new http.MultipartFile('img', stream, length, filename: filename));

      setState(() {
        isLoading = true;
      });
      // 发送请求
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          msg = "上报成功";
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

class SelectedItem {
  int value = 0;
}
