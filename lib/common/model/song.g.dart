// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      json['id'] as String,
      json['title'] as String,
      json['artist'] as String,
      json['artistId'] as String,
      json['album'] as String,
      json['albumId'] as String,
      json['sourceUrl'] as String,
      json['source'] as String,
      json['imgUrl'] as String,
      json['time'] as int,
      json['url'] as String,
      json['disabled'] as bool,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'artistId': instance.artistId,
      'album': instance.album,
      'albumId': instance.albumId,
      'sourceUrl': instance.sourceUrl,
      'source': instance.source,
      'imgUrl': instance.imgUrl,
      'url': instance.url,
      'time': instance.time,
      'disabled': instance.disabled,
    };
