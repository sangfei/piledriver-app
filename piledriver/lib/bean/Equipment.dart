import 'dart:convert';

/**
 * project class
 */
class Equipment {
  int equipmentid;
  String equipmentName;
  String equipmentBrand;
  String equipmentModel;
  String equipmentDiameter;
  int ownerid; //项目详情描述

  static List<Equipment> decodeData(String data) {
    List<Equipment> datas = new List<Equipment>();

    datas.clear();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static Equipment map(subject) {
    var bean = new Equipment();

    bean.equipmentid = subject['id'];
    bean.equipmentName = subject['name'].toString();
    bean.equipmentBrand = subject['brand'].toString();
    bean.equipmentModel = subject['model'].toString();
    bean.equipmentDiameter = subject['diameter'].toString();
    bean.ownerid = subject['ownerid'];
    return bean;
  }
}
