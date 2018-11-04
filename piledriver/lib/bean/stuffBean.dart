import 'dart:convert';

/**
 * project class
 */
class StuffBean {
  int stuffID;
  int title;
  String name; //名称
  String sex; //名称
  String phone; //名称
  String birth; //名称
  String pwd; //名称

  static List<StuffBean> decodeData(String data) {
    List<StuffBean> datas = new List<StuffBean>();

    datas.clear();
    var newData = json.decode(data);
    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static StuffBean map(subject) {
    var bean = new StuffBean();
    bean.stuffID = subject['id'];
    bean.title = subject['title'];
    bean.name = subject['name'].toString();
    bean.sex = subject['sex'].toString();
    bean.phone = subject['phone'].toString();
    bean.birth = subject['birth'].toString();
    bean.pwd = subject['pwd'].toString();
    return bean;
  }

  Map<String, dynamic> toJson() => {
        'id': stuffID,
        'title': title,
        'name': name,
        'sex': sex,
        'phone': phone,
        'birth': birth,
        'pwd': pwd,
      };
}
