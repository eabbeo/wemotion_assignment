import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/constants/app_constants.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/application/post_reply_services.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/models/replies_model.dart';

class PostReplyProvider extends ChangeNotifier {
  bool isLoading = false;
  List<List<RepliesModel>> replyLevels =
      []; // Stores multiple levels of replies
  int currentLevel = 0;

  int? _currentId;

  int get currentId => _currentId!;

  set currentId(int newId) {
    _currentId = newId;
    notifyListeners();
  }

  static const baseUrl = AppConstants.baseUrl;

  final PostReplyServices api = PostReplyServices();

  Future<void> loadMorePostReplies({bool isNewLevel = false}) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    try {
      final newPost = await api.fetchPostReplies(_currentId!);
      if (newPost != null) {
        if (isNewLevel) {
          replyLevels.add([newPost]);
          currentLevel++;
        } else {
          if (replyLevels.isNotEmpty) {
            replyLevels.last = [newPost];
          } else {
            replyLevels.add([newPost]);
          }
        }
      }
      log(replyLevels.toString());
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void goBackLevel() {
    if (currentLevel > 0) {
      currentLevel--;
      notifyListeners();
    }
  }

  List<RepliesModel> get currentReplies {
    return replyLevels.isNotEmpty && replyLevels.length > currentLevel
        ? replyLevels[currentLevel]
        : [];
  }
}

// class PostReplyProvider extends ChangeNotifier {
//   bool isLoading = false;
//   List<List<RepliesModel>> postReplies = [];

//   int? _id;

//   int get id => _id!;

//   set id(int newId) {
//     _id = newId;
//     notifyListeners();
//   }

//   static const baseUrl = AppConstants.baseUrl;

//   final PostReplyServices api = PostReplyServices();

//   Future<void> loadMorePostReplies() async {
//     if (isLoading) return;
//     isLoading = true;
//     notifyListeners();

//     try {
//       final newPost = await api.fetchPostReplies(id);
//       if (newPost != null) {
//         postReplies.add([newPost]);
//       }
//       log(postReplies.toString());
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
