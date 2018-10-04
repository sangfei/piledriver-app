
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class AddStuff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddStuffState();
  }
}

class AddStuffState extends State<AddStuff> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  String _name = '';
  String _sex = '';
  String _birth = '';
  String _title = '';
  String _phoneNum = '';
  String _verifyCode = '';

  

  addUserProfile() async {
    final response =
        await http.post('http://49.4.54.72:32500/api/v1/stuff?phone=$_phoneNum&name=$_name&sex=$_sex&birth=$_birth&title=$_title&pwd=$_verifyCode');
    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      print('======================resp $resp');

      return 0;
    } else {
      print('======================resp error ${response.body}');
      print("add user profile error");
      return "";
    }
  }

  _userLogIn(String name, String password) {
    addUserProfile().then((value) {
    
      print('=========================');
      if (0 == value) {
         // 清除导航纪录
        Navigator.pop(context);
      } else {
        showTips();
      }
    });
  }

 Widget _buildCustomBar() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
      children: <Widget>[
        new InkWell(
          child: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Icon(
                Icons.clear,
                size: 26.0,
                color: Colors.grey[700],
              )),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }


  Widget _buildLabel() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      alignment: Alignment.center,
      child: new Text(
        "增加新员工",
        style: new TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _buildRegist() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.blue[100],
        onPressed: (_phoneNum.isEmpty || _verifyCode.isEmpty|| _title.isEmpty
        || _name.isEmpty|| _birth.isEmpty|| _sex.isEmpty)
            ? null
            : () {
                _userLogIn(_phoneNum, _verifyCode);
              },
        child: new Text(
          "录  入",
          style: new TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

Widget _buildName() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _name = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '用户名',
          icon: new Icon(
            Icons.people,
          ),
        ),
        maxLines: 1,
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }

Widget _buildSex() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _sex = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '性别',
          icon: new Icon(
            Icons.person_add,
          ),
        ),
        maxLines: 1,
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  } 

  Widget _buildBirth() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: FlatButton(
    onPressed: () {
        DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
            print('change $date');
        }, onConfirm: (date) {
            print('confirm $date');
        }, currentTime: DateTime(2008, 12, 31, 23, 12, 34), locale: 'zh');
    },
    child: Text(
        'show date time picker (Chinese)',
        style: TextStyle(color: Colors.blue),
    )),
      // child: new TextField(
      //   onChanged: (str) {
      //     _birth = str;
      //     setState(() {});
      //   },
      //   decoration: new InputDecoration(
      //     hintText: '出生日期',
      //     icon: new Icon(
      //       Icons.date_range,
      //     ),
      //   ),
      //   maxLines: 1,
      //   onSubmitted: (text) {
      //     FocusScope.of(context).reparentIfNeeded(node);
      //   },
      // ),
    );
  } 

Widget _buildPhone() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _phoneNum = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '电话',
          icon: new Icon(
            Icons.phone,
          ),
        ),
        maxLines: 1,
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  } 


  Widget _buildPwd() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _verifyCode = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '密码',
          icon: new Icon(
            Icons.phone,
          ),
        ),
        maxLines: 1,
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }

Widget _buildTitle() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _title = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '职务',
          icon: new Icon(
            Icons.work,
          ),
        ),
        maxLines: 1,
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }  
  Widget _buildBody() {
    return new ListView(
      children: <Widget>[
        _buildCustomBar(),
        _buildLabel(),
        _buildName(),
        _buildSex(),
        _buildBirth(),
        _buildPhone(),
        _buildPwd(),
        _buildTitle(),
        _buildRegist(),
      ],
    );
  }

  showTips() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text('增加人员信息失败',
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
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }
}
