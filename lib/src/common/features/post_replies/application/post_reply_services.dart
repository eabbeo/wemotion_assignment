import 'dart:convert';

import 'package:wemotion_mobile/src/common/constants/app_constants.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/models/replies_model.dart';
import 'package:http/http.dart' as http;

class PostReplyServices {
  static const baseUrl = AppConstants.baseUrl;

  Future<RepliesModel?> fetchPostReplies(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$id/replies?page=1&page_size=5'),
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
      

        return RepliesModel.fromJson(data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
