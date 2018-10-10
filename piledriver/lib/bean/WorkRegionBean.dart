import 'dart:convert';

/**
 * project class
 */
class WorkRegionBean {
  final int id;
  final int projectID;
  final String name; //项目名称
  final String detail; //项目详情描述

  WorkRegionBean(this.id, this.projectID, this.name, this.detail);
  static List<WorkRegionBean> datas = new List<WorkRegionBean>();

  static List<WorkRegionBean> decodeData(String data) {
    datas.clear();
    var newData = json.decode(data);
    print('$newData');

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static WorkRegionBean map(subject) {
    print('$subject');
    return new WorkRegionBean(subject['id'], subject['projectid'],
        subject['name'].toString(), subject['desc'].toString());
  }
}
