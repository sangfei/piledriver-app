import 'dart:convert';

/**
 * statistic class
 */
class StatBean {
  final int id;
  final String type; //项目名称
  final double pieces; //项目详情描述

  StatBean(
      this.id, this.type, this.pieces);
  static List<StatBean> datas = new List<StatBean>();

  static List<StatBean> decodeData(String data) {
    datas.clear();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static StatBean map(subject) {
    print('$subject');
    return new StatBean(subject['id'], subject['name'].toString(),
        subject['pieces']);
  }
}
