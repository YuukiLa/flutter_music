class SpKeyConst {
  static String _cookie = "-cookie";
  static String _user = "-user";

  static String getCookieKey(String source) {
    return "$source$_cookie";
  }
  static String getUserKey(String source) {
    return "$source$_user";
  }
}