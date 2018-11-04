import 'package:piledriver/model/theme_model.dart';
import 'package:piledriver/bean/stuffBean.dart';

class CacheUtil {
  static List<ThemeModel> _themeModelList;

  static CacheUtil _singleton;

  static StuffBean _stuff;

  static DateTime _selectedTime;

  static DateTime _selectedEndTime;

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
    _selectedEndTime = null;

    _stuff = new StuffBean();
  }

  setThemeListCache(List<ThemeModel> list) {
    _themeModelList = list;
  }

  getThemeListCache() {
    return _themeModelList;
  }

  setTime(DateTime time) {
    _selectedTime = time;
  }

  setEndTime(DateTime time) {
    _selectedEndTime = time;
  }

  DateTime getEndTime() {
    return _selectedEndTime;
  }

  DateTime getTime() {
    return _selectedTime;
  }

  setUser(StuffBean stuff) {
    _stuff = stuff;
  }

  StuffBean getUser() {
    return _stuff;
  }
}
