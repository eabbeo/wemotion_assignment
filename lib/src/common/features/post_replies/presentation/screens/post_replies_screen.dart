import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/presentation/screens/feed_screens.dart';
import 'package:wemotion_mobile/src/common/widgets/video_player_widget.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/provider/reply_provider.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';
import 'package:wemotion_mobile/src/common/widgets/circle_widget.dart';
import 'package:page_transition/page_transition.dart';

class PostRepliesScreen extends StatefulWidget {
  final bool isNewLevel;
  const PostRepliesScreen({super.key, this.isNewLevel = false});

  @override
  State<PostRepliesScreen> createState() => _PostRepliesScreenState();
}

class _PostRepliesScreenState extends State<PostRepliesScreen> {
  int? currentIndex;
  String? above;
  String? below;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostReplyProvider>(context, listen: true);
    final screenSize = MediaQuery.of(context).size;
    final currentReplies = postProvider.currentReplies;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification) {
            if (scroll.metrics.pixels == scroll.metrics.minScrollExtent &&
                currentIndex == null) {
              // At top of first item
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: FeedScreen(),
                ),
              );
              //
            }
          }
          return false;
        },

        child: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: currentReplies.isNotEmpty
                  ? currentReplies[0].post.length
                  : 0,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                  if (currentReplies.isNotEmpty) {
                    int totalPosts = currentReplies[0].post.length;
                    above = currentIndex?.toString() ?? 'H';
                    below = (totalPosts - currentIndex! - 1).toString();
                  }
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0 &&
                        currentReplies.isNotEmpty &&
                        currentReplies[0]
                                .post[currentIndex ?? 0]
                                .childVideoCount >
                            0) {
                      postProvider.currentId =
                          currentReplies[0].post[currentIndex ?? 0].id;
                      postProvider.loadMorePostReplies(isNewLevel: true);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostRepliesScreen(isNewLevel: true),
                        ),
                      );
                    } else if (details.primaryVelocity! > 0) {
                      postProvider.goBackLevel();
                      Navigator.pop(context);
                    }
                  },
                  child: currentReplies.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : VideoPlayerWidget(
                          currentReplies[0].post[index].videoLink,
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
                                    imageUrl: currentReplies.isNotEmpty
                                        ? currentReplies[0]
                                              .post[currentIndex ?? 0]
                                              .pictureUrl
                                        : '',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),

                                Text(
                                  currentReplies.isNotEmpty
                                      ? currentReplies[0]
                                            .post[currentIndex ?? 0]
                                            .firstName
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  currentReplies.isNotEmpty
                                      ? currentReplies[0]
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
                              currentReplies.isNotEmpty
                                  ? currentReplies[0]
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
                              pointNorth: above == '' || above == '0'
                                  ? 'H'
                                  : above ?? 'H',
                              pointWest: 'P',
                              pointSouth: currentReplies.isEmpty && below == ''
                                  ? '0'
                                  : below != null
                                  ? below!
                                  : '${currentReplies[0].post.length - 1}',
                              pointEast: currentReplies.isNotEmpty
                                  ? '${currentReplies[0].post[currentIndex ?? 0].childVideoCount}'
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
