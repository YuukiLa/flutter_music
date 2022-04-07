import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  late String id;
  late String title;
  late String artist;
  late String artistId;
  late String album;
  late String albumId;
  late String sourceUrl;
  late String source;
  late String imgUrl;
  late String url;
  late bool disabled;

  Song(
      this.id,
      this.title,
      this.artist,
      this.artistId,
      this.album,
      this.albumId,
      this.sourceUrl,
      this.source,
      this.imgUrl,
      this.url,
      this.disabled);

  Song.name(
      {required this.id,
      required this.title,
      required this.artist,
      required this.artistId,
      required this.album,
      required this.albumId,
      required this.sourceUrl,
      required this.source,
      required this.imgUrl,
      required this.url,
      required this.disabled});

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "artistId": artistId,
      "album": album,
      "albumId": albumId,
      "sourceUrl": sourceUrl,
      "source": source,
      "imgUrl": imgUrl,
      "url": url,
      "disabled": disabled
    };
  }

  static Song fromMap(Map<String, dynamic> map) {
    return Song.name(
        id: map["id"],
        title: map["title"],
        artist: map["artist"],
        artistId: map["artistId"],
        album: map["album"],
        albumId: map["albumId"],
        sourceUrl: map["sourceUrl"],
        source: map["source"],
        imgUrl: map["imgUrl"],
        url: map["url"],
        disabled: map["disabled"]);
  }
}
