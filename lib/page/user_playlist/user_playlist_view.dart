import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';

import 'user_playlist_logic.dart';

class UserPlaylistPage extends GetView<UserPlaylistLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("用户歌单"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        return ListView.builder(
          itemBuilder: (context, index) {
            Playlist playlist = controller.state.playlists[index];
            return InkWell(
              onTap: () {
                controller.gotoDetail(playlist);
              },
                child: Container(
              height: 90,
              padding: const EdgeInsets.only(left: 10, right: 10),
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
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: playlist.coverImgUrl,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playlist.title,
                        style: const TextStyle(
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          "${playlist.count}首",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  )),
                  const Icon(Icons.chevron_right)
                ],
              ),
            ));
          },
          itemCount: controller.state.playlists.length,
        );
      }),
    );
  }
}
