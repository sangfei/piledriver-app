import 'dart:convert';

/**
 * project class
 */
class ConstructionBean {
  final int id;
  final int date;
  final double pieces;
  final int workregion;
  final int reporterid;
  final int status;
  final String reason;
  final int equipmentid;
  final String imageid;
  final String weather;
  final int ownerid;
  ConstructionBean(
      this.id,
      this.date,
      this.pieces,
      this.workregion,
      this.reporterid,
      this.status,
      this.reason,
      this.equipmentid,
      this.imageid,
      this.weather,
      this.ownerid);
  static List<ConstructionBean> datas = new List<ConstructionBean>();

  static List<ConstructionBean> decodeData(String data) {
    datas.clear();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static ConstructionBean map(subject) {
    print('$subject');
    return new ConstructionBean(
        subject['id'],
        subject['date'],
        subject['pieces'],
        subject['workregion'],
        subject['reporterid'],
        subject['status'],
        subject['reason'].toString(),
        subject['equipmentid'],
        subject['imageid'].toString(),
        subject['weather'].toString(),
        subject['ownerid']);
  }
}
