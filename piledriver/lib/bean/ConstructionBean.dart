import 'dart:convert';

/**
 * project class
 */
class ConstructionBean {
  int id;
  int date;
  double pieces;
  int workregion;
  int reporterid;
  int status;
  String reason;
  int equipmentid;
  String imageid;
  String weather;
  int ownerid;

  static List<ConstructionBean> decodeData(String data) {
    List<ConstructionBean> datas = new List<ConstructionBean>();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static ConstructionBean map(subject) {
    var bean = new ConstructionBean();
    bean.id = subject['id'];
    bean.date = subject['date'];
    bean.pieces = subject['pieces'];
    bean.workregion = subject['workregion'];
    bean.reporterid = subject['reporterid'];
    bean.status = subject['status'];
    bean.reason = subject['reason'].toString();
    bean.equipmentid = subject['equipmentid'];
    bean.imageid = subject['imageid'].toString();
    bean.weather = subject['weather'].toString();
    bean.ownerid = subject['ownerid'];
    return bean;
  }
}
