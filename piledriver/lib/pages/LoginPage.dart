import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:piledriver/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:piledriver/common/config/Config.dart';
import 'package:piledriver/common/local/LocalStorage.dart';
import 'package:piledriver/common/style/GSYStyle.dart';
import 'package:piledriver/widget/GSYFlexButton.dart';
import 'package:piledriver/widget/GSYInputWidget.dart';
import 'package:piledriver/common/constant.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  String _phoneNum = '';
  String _verifyCode = '';
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  @override
  void initState() {
    _readLoginData().then((Map onValue) {
      setState(() {
        _phoneNum = onValue["name"];
        _verifyCode = onValue["password"];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserProfile() async {
    final response =
        await http.get(Constant.baseUrl + '/api/v1/stuff?phone=$_phoneNum');
    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      print('======================resp $resp');

      return resp['pwd'];
    } else {
      print('======================resp error');
      print("get user profile error");
      return "";
    }
  }

  Future<Map> _readLoginData() async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/LandingInformation');
      String data = await file.readAsString();

      Map json = new JsonDecoder().convert(data);
      return json;
    } on FileSystemException {
      // 发生异常时返回默认值
      print("read exception");
      Map json = new JsonDecoder().convert('{"name":"","password":""}');
      return json;
    }
  }

  _userLogIn(String name, String password) {
    getUserProfile().then((value) {
      var userpwd = value;

      print('==============getpasswd===========$userpwd');
      if (userpwd == password) {
        print("$name $password");
        _saveLogin(name, password);
        // 清除导航纪录
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new MainPage();
          },
        ), (route) => route == null);
      } else {
        showTips();
      }
    });
  }

  Future<Null> _saveLogin(String name, String password) async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      String dir = (await getApplicationDocumentsDirectory()).path;
      await new File('$dir/LandingInformation')
          .writeAsString('{"name":"$name","password":"$password"}');
      print("save success");
    } on FileSystemException {
      // 发生异常时返回默认值
      print("save exception");
    }
  }

  Widget _buildPhoneEdit() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new TextField(
        onChanged: (str) {
          _phoneNum = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '请输入用户名',
          icon: new Icon(
            Icons.phone,
          ),
        ),
        maxLines: 1,
        maxLength: 11,
        //键盘展示为号码
        keyboardType: TextInputType.phone,
        //只能输入数字
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        hintText: '请输入密码',
        icon: new Icon(
          Icons.lock_outline,
        ),
      ),
      maxLines: 1,
      // maxLength: 12,
      obscureText: true,
      // //键盘展示为数字
      // keyboardType: TextInputType.number,
      // //只能输入数字
      // inputFormatters: <TextInputFormatter>[
      //   WhitelistingTextInputFormatter.digitsOnly,
      // ],
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          // new Align(
          //   alignment: Alignment.topRight,
          //   child: verifyCodeBtn,
          // ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      alignment: Alignment.center,
      child: new Text(
        "登录桩机管理系统",
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
        onPressed: (_phoneNum.isEmpty || _verifyCode.isEmpty)
            ? null
            : () {
                _userLogIn(_phoneNum, _verifyCode);
              },
        child: new Text(
          "登  录",
          style: new TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
        color: Colors.amber[200],
        child: new Center(
            child: new Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: Colors.white,
                margin: const EdgeInsets.all(30.0),
                child: new Padding(
                    padding: new EdgeInsets.only(
                        left: 30.0, top: 40.0, right: 30.0, bottom: 80.0),
                    // child: 
                    // new ListView(
                    //   children: <Widget>[
                    //     _buildLabel(),
                    //     _buildPhoneEdit(),
                    //     _buildVerifyCodeEdit(),
                    //     _buildRegist(),
                    //     // _buildTips(),
                    //     // _buildThirdPartLogin(),
                    //     // _buildProtocol(),
                    //   ],
                    // )
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Image(image: new AssetImage(GSYICons.DEFAULT_USER_ICON), width: 90.0, height: 90.0),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new GSYInputWidget(
                      hintText: "请输入手机号",
                      iconData: GSYICons.LOGIN_USER,
                      onChanged: (String value) {
                        _phoneNum = value;
                      },
                      controller: userController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new GSYInputWidget(
                      hintText: "请输入密码",
                      iconData: GSYICons.LOGIN_PW,
                      obscureText: true,
                      onChanged: (String value) {
                        _verifyCode = value;
                      },
                      controller: pwController,
                    ),
                    new Padding(padding: new EdgeInsets.all(30.0)),
                    new GSYFlexButton(
                      text: "登录",
                      color: Theme.of(context).primaryColor,
                      textColor: Color(GSYColors.textWhite),
                      onPress: () {
                        if (_phoneNum == null || _phoneNum.length == 0) {
                          return;
                        }
                        if (_verifyCode == null || _verifyCode.length == 0) {
                          return;
                        }
                         _userLogIn(_phoneNum, _verifyCode);
                        // CommonUtils.showLoadingDialog(context);
                        // UserDao.login(_userName.trim(), _password.trim(), store).then((res) {
                        //   Navigator.pop(context);
                        //   if (res != null && res.result) {
                        //     new Future.delayed(const Duration(seconds: 1), () {
                        //       NavigatorUtils.goHome(context);
                        //       return true;
                        //     });
                        //   }
                        // });
                      },
                    )
                  ],
                )
                    ))));
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
        body: _buildBody(),
      ),
    );
  }
}
