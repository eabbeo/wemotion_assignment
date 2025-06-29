import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/presentation/screens/video_player_widget.dart';
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
  // @override
  // void initState() {
  //   Future.delayed(Duration(seconds: 1), () {
  //     if (!mounted) return;
  //     final postProvider = Provider.of<PostReplyProvider>(
  //       context,
  //       listen: false,
  //     );
  //     postProvider.loadMorePostReplies();
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostReplyProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final postReply = Provider.of<PostReplyProvider>(context, listen: false);

    return Scaffold(
      // backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            postProvider.loadMorePostReplies();
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
                    if (details.primaryVelocity! < 0) {
                      // //passing feed id to post or replies provider
                      // postReply.id = postProvider.postReplies[0].post[index].id;

                      // postReply.loadMorePostReplies();
                      // //
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PostRepliesScreen(),
                      //   ),
                      // );

                      // log('...Index id is ${postReply.id}');
                      // log('....Provider id is ${postReply.id}');
                      // //

                      // Swiped right to left
                    } else if (details.primaryVelocity! > 0) {
                      // Swiped left to right
                      Navigator.pop(context); // or navigate to previous page
                    }
                  },
                  child: PageView.builder(
                    itemCount: postProvider.postReplies.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return VideoPlayerWidget(
                        postReply.postReplies.isNotEmpty
                            ? postProvider.postReplies[0].post[index].videoLink
                            : '',
                      );
                    },
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
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
                              pointNorth: 0,
                              pointWest: 0,
                              pointSouth: 0,
                              pointEast: 0,
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
