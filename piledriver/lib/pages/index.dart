import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'mine.dart';
import 'construction.dart';

class IndexPage extends StatefulWidget {
  @override
  createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  // 定义底部导航列表
  final List<BottomNavigationBarItem> bottomTabs = [
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.home),
      title: new Text('项目'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.share_up),
      title: new Text('施工'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.profile_circled),
      title: new Text('我'),
    )
  ];

  final List<Widget> tabBodies = [
    new HomePage(),
    new ConstructionPage(title: '施工信息录入'),
    new MinePage()
  ];
  int currentIndex = 0; //当前索引
  Widget currentPage; //当前页面

  @override
  void initState() {
    super.initState();
    currentPage = tabBodies[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: new Color.fromRGBO(244, 245, 245, 1.0),
        bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: bottomTabs,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              currentPage = tabBodies[currentIndex];
            });
          },
        ),
        body: currentPage
        );
  }
}
