import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unknown/common/utils/dialog.dart';

import '../model/song.dart';

class SongItem extends StatelessWidget {
  late Song song;
  late VoidCallback? tap;
  late VoidCallback? longTap;
  SongItem({Key? key, required this.song,this.tap,this.longTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(tap!=null) {
          tap!();
        }
      },
      onLongPressStart: (LongPressStartDetails details) {
        print("long press");
        DialogUtil.showPopupMenu(context, details.globalPosition.dx, details.globalPosition.dy, ["收藏到歌单"], (value) {
          if(longTap!=null && value!=null) {
            longTap!();
          }
        });

      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        width: double.maxFinite,
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
      ),
    );
  }
}

