import 'dart:convert';

/**
 * project class
 */
class ProjectBean {
  int projectID;
  String projectName; //项目名称
  String projectDetail; //项目详情描述
  String partya; //项目详情描述

  static List<ProjectBean> decodeData(String data) {
    List<ProjectBean> datas = new List<ProjectBean>();

    datas.clear();
    var newData = json.decode(data);

    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static ProjectBean map(subject) {
    var bean = new ProjectBean();
    bean.projectID = subject['id'];
    bean.projectName = subject['name'].toString();
    bean.projectDetail = subject['desc'].toString();
    bean.partya = subject['partya'].toString();
    return bean;
  }
}
