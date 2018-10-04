import 'dart:convert';

/**
 * project class
 */
class ProjectBean {
  final int projectID;
  final String projectName;//项目名称
  final String projectDetail;//项目详情描述

  ProjectBean(this.projectID, this.projectName, this.projectDetail);
  static List<ProjectBean> datas=new List<ProjectBean>();

  static List<ProjectBean> decodeData(String data) {
      datas.clear();
      var newData = json.decode(data);
      //肯定首先是知道他是一个数组，或者是集合
      for(int i=0;i<newData.length;i++){
         datas.add(map(newData[i]));
      }
     return datas;
  }

  static ProjectBean map(subject) {
    return new ProjectBean(subject['machineId'], subject['name'].toString(), subject['desc'].toString());
  }
}
