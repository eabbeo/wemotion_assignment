import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/features/Home/application/feed_serivces.dart';
import 'package:wemotion_mobile/src/common/features/Home/data/models/feeds_models.dart';

class FeedProvider extends ChangeNotifier {
  List<FeedModel> feeds = [];
  bool isLoading = false;
  int currentPage = 1;

  final FeedSerivces api = FeedSerivces();

  Future<void> loadMoreFeeds() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    try {
      final newFeed = await api.fetchFeeds(currentPage);
      if (newFeed != null) {
        feeds.add(newFeed);
        currentPage++;
      }
    } catch (e) {
      print("Failed to load feeds: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
