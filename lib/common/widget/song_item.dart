import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/song.dart';

class SongItem extends StatefulWidget {
  late Song song;
  SongItem({Key? key, required this.song}) : super(key: key);

  @override
  State<SongItem> createState() => _SongItemState(song);
}

class _SongItemState extends State<SongItem> {
  late Song song;
  _SongItemState(this.song);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 70,
      child: Row(
        children: [
          Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: song.imgUrl,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.title,
                style: const TextStyle(
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  song.artist,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
