import 'dart:convert';

/**
 * project class
 */
class Equipment {
  final int equipmentid;
  final String equipmentName;
  final String equipmentBrand;
  final String equipmentModel;
  final String equipmentDiameter;
  final int ownerid; //项目详情描述

  Equipment(this.equipmentid, this.equipmentName, this.equipmentBrand,
      this.equipmentModel, this.equipmentDiameter, this.ownerid);
  static List<Equipment> datas = new List<Equipment>();

  static List<Equipment> decodeData(String data) {
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
    print('$subject');
    return new Equipment(
        subject['id'],
        subject['name'].toString(),
        subject['brand'].toString(),
        subject['model'].toString(),
        subject['diameter'].toString(),
        subject['ownerid']);
  }
}
