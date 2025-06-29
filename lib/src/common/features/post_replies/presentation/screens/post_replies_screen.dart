import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/widgets/video_player_widget.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/provider/reply_provider.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';
import 'package:wemotion_mobile/src/common/widgets/circle_widget.dart';

class PostRepliesScreen extends StatefulWidget {
  const PostRepliesScreen({super.key});

  @override
  State<PostRepliesScreen> createState() => _PostRepliesScreenState();
}

class _PostRepliesScreenState extends State<PostRepliesScreen> {
  int? currentIndex;
  String? above;
  String? below;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostReplyProvider>(context, listen: true);
    final screenSize = MediaQuery.of(context).size;
    final postReply = Provider.of<PostReplyProvider>(context, listen: false);

    return Scaffold(
      // backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            // postProvider.loadMorePostReplies();
          }
          return true;
        },
        child: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: postProvider.postReplies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    // Detect horizontal swipe direction
                    if (details.primaryVelocity! < 0 &&
                        postProvider
                                .postReplies[0]
                                .post[currentIndex ?? 0]
                                .childVideoCount >
                            0) {
                      //passing feed id to post or replies provider
                      postReply.id = postProvider
                          .postReplies[0]
                          .post[currentIndex ?? 0]
                          .id;
                      postReply.loadMorePostReplies();
                      // Swiped right to left
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostRepliesScreen(),
                        ),
                      );
                    }
                  },
                  child: PageView.builder(
                    itemCount: postProvider.postReplies[0].post.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return postProvider.postReplies.isEmpty
                          ? Center(child: CircularProgressIndicator.adaptive())
                          : VideoPlayerWidget(
                              postProvider.postReplies[0].post[index].videoLink,
                            );
                    },
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                        int totalPosts =
                            postProvider.postReplies[0].post.length;
                        above = currentIndex!.toString();
                        below = (totalPosts - currentIndex! - 1).toString();
                      });
                    },
                  ),
                );
              },
            ),

            //
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: screenSize.width,
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //left design side
                    SizedBox(
                      width: screenSize.width * 0.7,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 3,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    50,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        postProvider.postReplies.isNotEmpty
                                        ? postProvider
                                              .postReplies[0]
                                              .post[currentIndex ?? 0]
                                              .pictureUrl
                                        : '',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),

                                Text(
                                  postProvider.postReplies.isNotEmpty
                                      ? postProvider
                                            .postReplies[0]
                                            .post[currentIndex ?? 0]
                                            .firstName
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  postProvider.postReplies.isNotEmpty
                                      ? postProvider
                                            .postReplies[0]
                                            .post[currentIndex ?? 0]
                                            .lastName
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            //
                            Text(
                              postProvider.postReplies.isNotEmpty
                                  ? postProvider
                                        .postReplies[0]
                                        .post[currentIndex ?? 0]
                                        .title
                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    //right design side
                    SizedBox(
                      width: screenSize.width * 0.3,
                      //height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 15,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.greyColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.greyColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.greyColor.withValues(
                              alpha: 0.5,
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleWithFiveDirections(
                              pointNorth: 'H',
                              pointWest: 'P',
                              pointSouth: '0',
                              pointEast:
                                  postProvider.postReplies.isNotEmpty &&
                                      postProvider
                                          .postReplies[0]
                                          .post
                                          .isNotEmpty
                                  ? '${postProvider.postReplies[0].post[currentIndex ?? 0].childVideoCount}'
                                  : '0',
                              mainCircleColor: Colors.yellow,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
