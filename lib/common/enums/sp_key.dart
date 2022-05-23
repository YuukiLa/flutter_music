class SpKeyConst {
  static String _cookie = "-cookie";
  static String _user = "-user";
  static String playlistKey = "playingList";
  static String playIndexKey = "playingIndex";

  static String getCookieKey(String source) {
    return "$source$_cookie";
  }

  static String getUserKey(String source) {
    return "$source$_user";
  }
}
