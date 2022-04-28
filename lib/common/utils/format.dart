class TimeFormatUtil {
  static String timeFormat(int ms) {
    var m = (ms / 1000 / 60).floor();
    var s = (ms / 1000).floor();
    return "${_addZero(m % 60)}:${_addZero(s % 60)}";
  }

  static String _addZero(int n) {
    return n < 10 ? "0$n" : n.toString();
  }
}
