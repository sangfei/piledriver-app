import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class StuffList extends StatefulWidget {

  @override
  StuffListState createState() => new StuffListState();
}

class StuffListState extends State<StuffList> {
//  获取projectlist
  Future getStuffList() async {

    final response = await http
        .get('http://49.4.54.72:32500/api/v1/list/stuff');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStuffList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('===============================================');
          print('snapshot is :${snapshot.data}');
          return new Scaffold(
            backgroundColor: Colors.white,
            appBar: new CupertinoNavigationBar(
              backgroundColor: Colors.blue,
              middle: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Text(
                    '员工列表',
                    style: new TextStyle(fontWeight: FontWeight.normal),
                  )),
            ),
            body: _buildSuggestions(snapshot.data),
            floatingActionButton: new FloatingActionButton(
            onPressed: (){Navigator.pushNamed(context, '/addStuff');},
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        } else if (snapshot.hasError) {
          return Text("error1>>>>>>>>>>>>>>>:${snapshot.error}");
        }
        return new Container(
          color: new Color.fromRGBO(244, 245, 245, 1.0),
        );
      },
    );
  }

  //定义一个子控件，这个控件就是放置随机字符串词组的列表
  Widget _buildSuggestions(stuffList) {
    // return _getListView();
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(1.0)),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  _tableHeader(),
                  new Container(
                    height: 500.0,
                    width: double.infinity,
                    child: _buildSuggestions1(stuffList),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _tableHeader() {
    return new Table(
        columnWidths: <int, TableColumnWidth>{
          0: FlexColumnWidth(10.0),
          1: FlexColumnWidth(25.0),
          2: FlexColumnWidth(15.0),
          3: FlexColumnWidth(20.0),
          4: FlexColumnWidth(20.0),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
            color: Colors.black38, width: 0.3, style: BorderStyle.solid),
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Container(
                child: SizedBox(
                  height: 35.0,
                  child: new Align(
                    alignment: Alignment.center,
                    widthFactor: 2.0,
                    heightFactor: 2.0,
                    child: Text('姓名'),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: 35.0,
                  child: new Align(
                    alignment: Alignment.center,
                    widthFactor: 2.0,
                    heightFactor: 2.0,
                    child: Text('生日'),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: 35.0,
                  child: new Align(
                    alignment: Alignment.center,
                    widthFactor: 2.0,
                    heightFactor: 2.0,
                    child: Text('性别'),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: 35.0,
                  child: new Align(
                    alignment: Alignment.center,
                    widthFactor: 2.0,
                    heightFactor: 2.0,
                    child: Text('电话'),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: 35.0,
                  child: new Align(
                    alignment: Alignment.center,
                    widthFactor: 2.0,
                    heightFactor: 2.0,
                    child: Text('密码'),
                  ),
                ),
              ),
            ],
          )
        ]);
  }

  _table(item, i) {
    return new Table(
      columnWidths: <int, TableColumnWidth>{
        0: FlexColumnWidth(10.0),
        1: FlexColumnWidth(25.0),
        2: FlexColumnWidth(15.0),
        3: FlexColumnWidth(20.0),
        4: FlexColumnWidth(20.0),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          color: Colors.black38, width: 0.2, style: BorderStyle.solid),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              child: SizedBox(
                height: 35.0,
                child: new Align(
                  alignment: Alignment.center,
                  widthFactor: 2.0,
                  heightFactor: 2.0,
                  child: Text('${item['name']}'),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                height: 35.0,
                child: new Align(
                  alignment: Alignment.center,
                  widthFactor: 2.0,
                  heightFactor: 2.0,
                  child: Text('${item['birth']}'),
                  
                ),
              ),
            ),
            Container(
              child: SizedBox(
                height: 35.0,
                child: new Align(
                  alignment: Alignment.center,
                  widthFactor: 2.0,
                  heightFactor: 2.0,
                  child: Text('${item['sex']}'),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                height: 35.0,
                child: new Align(
                  alignment: Alignment.center,
                  widthFactor: 2.0,
                  heightFactor: 2.0,
                  child: Text('${item['phone']}'),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                height: 35.0,
                child: new Align(
                  alignment: Alignment.center,
                  widthFactor: 2.0,
                  heightFactor: 2.0,
                  child: Text('${item['pwd']}'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //定义一个子控件，这个控件就是放置随机字符串词组的列表
  Widget _buildSuggestions1(projectList) {
    return new ListView.builder(
        itemCount: projectList.length,
        //ListView(列表视图)是material.dart中的基���控件
        padding: const EdgeInsets.all(1.0), //padding(内边距)是ListView的属性，配置其属性值
        //���过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
        //此函数会自动循环并计数，咋结束的我也不知道，走着瞧咯
        itemBuilder: (context, i) {
          var item = projectList[i];
          print("$item");
          // print(item);
          return _buildRow(item, i); //把这个数据项塞入ListView中
        });
  }

  //定义的_suggestions数组项属性
  Widget _buildRow(item, i) {
    return new Container(
      child: _table(item, i),
      // decoration: const BoxDecoration(
      //     border: const Border(
      //       top: const BorderSide(width: 1.0, color: Colors.black38),
      //     ),
      //     color: Colors.white),
    );
  }
}
