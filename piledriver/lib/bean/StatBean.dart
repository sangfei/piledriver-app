import 'dart:convert';

/**
 * statistic class
 */
class StatBean {
  int id = 0;
  String type = ''; //项目名称
  double pieces = 0.0; //项目详情描述

  static List<StatBean> decodeData(String data) {
    List<StatBean> datas = new List<StatBean>();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static StatBean map(subject) {
    var bean = new StatBean();
    bean.id = subject['id'];
    bean.type = subject['type'].toString();
    bean.pieces = subject['pieces'];
    return bean;
  }
}
