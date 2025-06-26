import 'package:cached_video_player_plus/cached_video_player_plus.dart';
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

    return Scaffold(
      // backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            feedProvider.loadMoreFeeds();
          }
          return true;
        },
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: feedProvider.feeds.length,
          itemBuilder: (context, index) {
            final feed = feedProvider.feeds[index];
            return PageView.builder(
              itemCount: feed.posts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return VideoPlayerWidget(
                  feedProvider.feeds[index].posts[index].videoLink,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
