// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      json['coverImgUrl'] as String,
      json['title'] as String,
      json['id'] as String,
      json['sourceUrl'] as String,
      json['source'] as String,
    )..isSub = json['isSub'] as bool;

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'coverImgUrl': instance.coverImgUrl,
      'title': instance.title,
      'id': instance.id,
      'sourceUrl': instance.sourceUrl,
      'source': instance.source,
      'isSub': instance.isSub,
    };
