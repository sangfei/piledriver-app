import 'dart:convert';

/**
 * project class
 */
class StuffBean {
  final int stuffID;
  final int title;
  final String name; //名称
  final String sex; //名称
  final String phone; //名称
  final String birth; //名称
  final String pwd; //名称

  StuffBean(this.stuffID, this.title, this.name, this.sex, this.phone, this.birth, this.pwd);
  static List<StuffBean> datas = new List<StuffBean>();

  static List<StuffBean> decodeData(String data) {
    datas.clear();
    var newData = json.decode(data);
    //肯定首先是知道他是一个数组，或者是集合
    for (int i = 0; i < newData.length; i++) {
      datas.add(map(newData[i]));
    }
    return datas;
  }

  static StuffBean map(subject) {
    return new StuffBean(subject['id'], subject['title'], subject['name'].toString(),
        subject['sex'].toString(),subject['phone'].toString(),subject['birth'].toString(),subject['pwd'].toString());
  }
}
