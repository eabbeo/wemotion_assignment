import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/data/provider/feed_provider.dart';
import 'package:wemotion_mobile/src/common/features/Home/presentation/screens/video_player_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
                    Container(
                      width: screenSize.width * 0.7,
                      height: 100,
                      color: Colors.blue,
                    ),
                    //right design side
                    Container(
                      width: screenSize.width * 0.3,
                      height: 100,
                      color: Colors.yellow,
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
