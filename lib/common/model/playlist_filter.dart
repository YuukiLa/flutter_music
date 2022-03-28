
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';

class PlaylistFilter {
  late List<Filter> recommend;
  late List<Category> all;
  PlaylistFilter(this.recommend,this.all);
}