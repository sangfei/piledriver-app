import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piledriver/pages/mine.dart';

class DrawerPage extends StatefulWidget {
  @override
  createState() => new DrawerPageState();
}

class DrawerPageState extends State<DrawerPage> {
  static Widget homeDrawer(context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(context),
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: new Text("A")),
          title: new Text('Drawer item A'),
          onTap: () => {},
        ),
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Text("B")),
        title: new Text('Drawer item B'),
        subtitle: new Text("Drawer item B subtitle"),
        onTap: () => {},
      ),
      new AboutListTile(
        icon: new CircleAvatar(child: new Text("Ab")),
        child: new Text("About"),
        applicationName: "Test",
        applicationVersion: "1.0",
        applicationIcon: new Image.asset(
          "static/images/logo.png",
          width: 64.0,
          height: 64.0,
        ),
        applicationLegalese: "applicationLegalese",
        aboutBoxChildren: <Widget>[
          new Text("BoxChildren"),
          new Text("box child 2")
        ],
      ),
    ]);
  }

  static Widget _drawerHeader(context) {
    return new UserAccountsDrawerHeader(
//      margin: EdgeInsets.zero,
      accountName: new Text(
        "sangfei",
      ),
      accountEmail: new Text(
        "feisang@126.com",
      ),
      currentAccountPicture: new GestureDetector(
          //用户头像
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new MinePage()));
              
          },
          child: new CircleAvatar(
            backgroundImage: new NetworkImage(
                'http://n.sinaimg.cn/translate/20170726/Zjd3-fyiiahz2863063.jpg'),
          )),
      onDetailsPressed: () {},
      // otherAccountsPictures: <Widget>[
      //   new CircleAvatar(
      //     backgroundImage: new NetworkImage(
      //       'http://n.sinaimg.cn/translate/20170726/Zjd3-fyiiahz2863063.jpg'),
      //   ),
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: homeDrawer(context),
    );
  }
}
