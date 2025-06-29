import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/data/provider/feed_provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/presentation/screens/video_player_widget.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/provider/reply_provider.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/presentation/screens/post_replies_screen.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';
import 'package:wemotion_mobile/src/common/widgets/circle_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int? currentIndex;
  int? above;
  int? below;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.loadMoreFeeds();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final postReply = Provider.of<PostReplyProvider>(context, listen: false);
    //totalFeeds = feedProvider.feeds[0].posts.length;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            feedProvider.loadMoreFeeds();
          }
          return true;
        },
        child: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: feedProvider.feeds.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    // Detect horizontal swipe direction
                    if (details.primaryVelocity! < 0 &&
                        feedProvider
                                .feeds[0]
                                .posts[currentIndex ?? 0]
                                .childVideoCount >
                            0) {
                      //passing feed id to post or replies provider
                      postReply.id =
                          feedProvider.feeds[0].posts[currentIndex ?? 0].id;
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
                    itemCount: feedProvider.feeds[0].posts.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return feedProvider.feeds.isEmpty
                          ? Center(child: CircularProgressIndicator.adaptive())
                          : VideoPlayerWidget(
                              feedProvider.feeds[0].posts[index].videoLink,
                            );
                    },
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                        int totalPosts = feedProvider.feeds[0].posts.length;
                        above = currentIndex!;
                        below = totalPosts - currentIndex! - 1;
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
                                    imageUrl: feedProvider.feeds.isNotEmpty
                                        ? feedProvider
                                              .feeds[0]
                                              .posts[currentIndex ?? 0]
                                              .pictureUrl
                                        : '',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),

                                Text(
                                  feedProvider.feeds.isNotEmpty
                                      ? feedProvider
                                            .feeds[0]
                                            .posts[currentIndex ?? 0]
                                            .firstName
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  feedProvider.feeds.isNotEmpty
                                      ? feedProvider
                                            .feeds[0]
                                            .posts[currentIndex ?? 0]
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
                              feedProvider.feeds.isNotEmpty
                                  ? feedProvider
                                        .feeds[0]
                                        .posts[currentIndex ?? 0]
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
                              pointNorth: above ?? 0,
                              pointWest: 0,
                              pointSouth:
                                  feedProvider.feeds.isEmpty && below == null
                                  ? 0
                                  : below != null
                                  ? below!
                                  : feedProvider.feeds[0].posts.length - 1,

                              //  feedProvider.feeds.isNotEmpty
                              //     ? below ?? 0
                              //     : feedProvider.feeds.isNotEmpty
                              //     ? feedProvider.feeds[0].posts.length - 1
                              //     : 0,
                              pointEast: feedProvider.feeds.isNotEmpty
                                  ? feedProvider
                                        .feeds[0]
                                        .posts[currentIndex ?? 0]
                                        .childVideoCount
                                  : 0,
                              mainCircleColor: Colors.deepPurple,
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
