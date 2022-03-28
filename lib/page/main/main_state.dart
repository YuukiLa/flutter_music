import 'package:get/get.dart';

class MainState {
  var _currPage=0.obs;
  set currPage(value)=> _currPage.value=value;
  get currPage=> _currPage.value;

}
