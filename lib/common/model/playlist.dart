import 'package:json_annotation/json_annotation.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist {
  late String coverImgUrl;
  late String title;
  late String id;
  late String sourceUrl;
  late String source;
  late bool isSub;

  Playlist(this.coverImgUrl, this.title, this.id, this.sourceUrl, this.source);

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
