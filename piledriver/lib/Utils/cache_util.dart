import 'package:piledriver/model/theme_model.dart';
import 'package:piledriver/bean/stuffBean.dart';
class CacheUtil {

  static List<ThemeModel> _themeModelList;

  static CacheUtil _singleton;

  static StuffBean _stuff;

  static DateTime _selectedTime;

  static CacheUtil getInstance() {
    if (_singleton == null) {
      _singleton = new CacheUtil._internal();
      _singleton._init();
    }

    return _singleton;
  }

  CacheUtil._internal();

  _init() {
    _themeModelList = [];
    _selectedTime = null;
    _stuff = new StuffBean(0,0,'','','','','');
  }

  setThemeListCache(List<ThemeModel> list) {
    _themeModelList = list;
  }

  getThemeListCache() {
    return _themeModelList;
  }

  setTime(DateTime time)
  {
    _selectedTime = time;
  }

  DateTime getTime()
  {
    print("==========_selectedTime:"+_selectedTime.toString());
    return _selectedTime;
  }

  setUser(StuffBean stuff)
  {
    _stuff = stuff;
  }

  StuffBean getUser()
  {
    return _stuff;
  }
}
