import 'package:piledriver/pages/construction/ChartFlutterBean.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SystemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SystemPagerState();
  }
}

class SystemPagerState extends State<SystemPage> {
  bool animate;
  List<Widget> widgetList = List();

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            actions: <Widget>[
              new Container(
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
              //只能用金泰的？
            ],
            leading: Icon(Icons.add),
            // title:Text('Demo'),
            centerTitle: true,
            pinned: true,
            //是否固定。
            backgroundColor: Colors.white,
            expandedHeight: 150.0,
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.asset(
                'images/lonvn9.jpg',
                fit: BoxFit.cover,
              ),
              centerTitle: false,
              title: const Text('图表学习'),
            ),
          ),
          new SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widgetList[index];
              },
              childCount: widgetList.length,
            ),
          ),
        ],
      ),
    );
  }

  void loadChartData() async {
    //0.标题
    //1.折线图
    widgetList.add(
      new charts.TimeSeriesChart(
        ChartFlutterBean.createSampleData0(),
        animate: animate,
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: new charts.LocalDateTimeFactory(),
      ),
    );
    //2.病壮图
    widgetList.add(

          new charts.PieChart(ChartFlutterBean.createSampleData1(),
        animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]))
    );
    //3.银光棒图。哈哈
    widgetList.add(
      new charts.ScatterPlotChart(
        ChartFlutterBean.createSampleData3(),
        animate: animate,
        defaultRenderer: new charts.PointRendererConfig(
          pointRendererDecorators: [
            new charts.ComparisonPointsDecorator(
              symbolRenderer: new charts.CylinderSymbolRenderer(),
            ),
          ],
        ),
      ),
    );
    //条形
    widgetList.add(
      new charts.BarChart(
        ChartFlutterBean.createSampleData(),
        animate: animate,
        barGroupingType: charts.BarGroupingType.groupedStacked,
      ),
    );
    //柱状图
    widgetList.add(
      new charts.BarChart(
        new ChartFlutterBean().getData(),
        animate: animate,
        behaviors: [
          new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 2),
        ],
      ),
    );
  }
}
