import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:piledriver/bean/StatBean.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withGivingData(
      List<StatBean> datas, String type) {
    return new DonutAutoLabelChart(
      _createData(datas, type),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto)
        ]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createData(
      List<StatBean> givingdatas, String type) {
    List<LinearSales> data = [];
    for (int i = 0; i < givingdatas.length; i++) {
      if (givingdatas[i].pieces <= 0) {
        print("in pie has zero number:" + type);
        continue;
      }
      data.add(new LinearSales(givingdatas[i].equipmentname, givingdatas[i].pieces));
    }

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.name,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.name}: ${row.sales}',
      )
    ];
  }

}

/// Sample linear data type.
class LinearSales {
  final String name;
  final double sales;

  LinearSales(this.name, this.sales);
}
