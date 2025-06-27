import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/data/provider/feed_provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/presentation/screens/video_player_widget.dart';
import 'package:wemotion_mobile/src/common/widgets/circle_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int? currentIndex;
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
                return PageView.builder(
                  itemCount: feedProvider.feeds[0].posts.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return VideoPlayerWidget(
                      feedProvider.feeds[0].posts[index].videoLink,
                    );
                  },
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                );
              },
            ),

            //
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: screenSize.width,

                child: Row(
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
                      height: 100,
                      child: CircleWithFiveDirections(),
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
