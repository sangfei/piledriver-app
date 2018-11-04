import 'dart:convert';

/**
 * statistic class
 */
class StatBean {
  int id = 0;
  int projectid = 0;
  int workregionid = 0;
  int equipmentid = 0;
  int ownerid = 0;
  String projectname;
  String workregionname;
  String equipmentname;
  String ownername;
  String type = '';
  double pieces = 0.0;
  double totalpieces = 0.0;

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
    bean.totalpieces = subject['totalpieces'];
    bean.projectname = subject['projectname'];
    bean.workregionname = subject['workregionname'];
    bean.equipmentname = subject['equipmentname'];
    bean.ownername = subject['ownername'];
    bean.projectid = subject['projectid'];
    bean.workregionid = subject['workregionid'];
    bean.equipmentid = subject['equipmentid'];
    bean.ownerid = subject['ownerid'];
    return bean;
  }
}
