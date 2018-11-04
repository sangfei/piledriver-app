import 'dart:convert';

/**
 * project class
 */
class WorkRegionBean {
  int id;
  int projectID;
  String name; //项目名称
  String detail; //项目详情描述

  static List<WorkRegionBean> decodeData(String data) {
    List<WorkRegionBean> datas = new List<WorkRegionBean>();
    datas.clear();
    var newData = json.decode(data);
    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static WorkRegionBean map(subject) {
    var bean = new WorkRegionBean();
    bean.id = subject['id'];
    bean.projectID = subject['projectid'];
    bean.name = subject['name'].toString();
    bean.detail = subject['desc'].toString();
    return bean;
  }
}
