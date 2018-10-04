import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:piledriver/pages/constructionDetail.dart';
import 'package:piledriver/bean/projectBean.dart';
import 'package:http/http.dart' as http;

class ProjectDetail extends StatefulWidget {
  final ProjectBean projectInfo;

  ProjectDetail(this.projectInfo);

  @override
  ProjectDetailState createState() => new ProjectDetailState();
}

class ProjectDetailState extends State<ProjectDetail>
    with TickerProviderStateMixin {
//  获取projectlist
  Future getProjects() async {
    print('============');
    final response = await http.get(
        'http://49.4.54.72:32500/api/v1/workregion?projectid=${widget.projectInfo.projectID}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  _noDataView(project) {
    print("error data");
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        backgroundColor: Colors.amber[200],
        middle: new Text(
          project.projectName,
          style: new TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: new Container(child: new Center(child: new Text("没有数据"))),
    );
  }

  Widget _buildProjectContent(projectList) {
    return new ListView.builder(
        itemCount: projectList.length,
        //ListView(列表视图)是material.dart中的基础控件
        padding: const EdgeInsets.all(1.0), //padding(内边距)是ListView的属性，配置其属性值
        //通过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
        //此函数会自动循环并计数，咋结束的我也不知道，走着瞧咯
        itemBuilder: (context, i) {
          print(i);
          var item = projectList[i];
          print(item);
          return _buildRow(item); //把这个数据项塞入ListView中
        });
  }

  Widget _buildRow(item) {
    return new Container(
      child: new ListTile(
        leading: new Icon(
          Icons.landscape,
          color: Colors.orange,
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        title: new Text(item['name']),
        onTap: () {
          Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) => ConstructionDetail(workRegion: item)));
        },
        enabled: true,
      ),
      decoration: const BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
                width: 1.0, color: const Color.fromRGBO(215, 217, 220, 1.0)),
          ),
          color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    var project = widget.projectInfo;

    return FutureBuilder(
      future: getProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot is :${snapshot.data}');
          // 返回值为空，这里以后要封装起来
          if ((snapshot.data.toString()) == "[]") {
            return _noDataView(project);
          } else {
            // 正常有数据的场景
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 200.0,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(project.projectName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          background: Image.network(
                            "http://127.0.0.1:8080/image/load/123.jpg",
                            fit: BoxFit.fill,
                          )),
                    ),
                    SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: new TabController(length: 2, vsync: this),
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(icon: Icon(Icons.landscape), text: "施工地块"),
                          Tab(icon: Icon(Icons.credit_card), text: "项目详情"),
                        ],
                      ),
                    ))
                  ];
                },
                body: _buildProjectContent(snapshot.data),
              ),
            );
          }
        } else if (snapshot.hasError) {
          _noDataView(project);
        }
        return new Container(
          color: new Color.fromRGBO(244, 245, 245, 1.0),
        );
      },
    );
  }
}

class ListItem {
  final String title;
  final IconData iconData;

  ListItem(this.title, this.iconData);
}

class ListItemWidget extends StatelessWidget {
  final ListItem listItem;

  ListItemWidget(this.listItem);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new ListTile(
        leading: new Icon(listItem.iconData),
        title: new Text(listItem.title),
      ),
      onTap: () {},
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
