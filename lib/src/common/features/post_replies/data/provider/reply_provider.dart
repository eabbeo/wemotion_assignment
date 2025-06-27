import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/constants/app_constants.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/application/post_reply_services.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/models/replies_model.dart';

class ReplyProvider extends ChangeNotifier {
  bool isLoading = false;
  List<RepliesModel> postReplies = [];
  int? _id;

  int get id => _id!;

  set id(int newId) {
    _id = newId;
    notifyListeners();
  }

  static const baseUrl = AppConstants.baseUrl;

  final PostReplyServices api = PostReplyServices();

  Future<void> loadMorePostReplies() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    try {
      final newPost = await api.fetchPostReplies(id);
      if (newPost != null) {
        postReplies.add(newPost);
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
