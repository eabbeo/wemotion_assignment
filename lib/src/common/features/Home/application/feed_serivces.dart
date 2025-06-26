import 'dart:convert';

import 'package:wemotion_mobile/src/common/constants/app_constants.dart';
import 'package:wemotion_mobile/src/common/features/Home/data/models/feeds_models.dart';
import 'package:http/http.dart' as http;

class FeedSerivces {
  static const baseUrl = AppConstants.baseUrl;

  Future<FeedModel?> fetchFeeds(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/feed?page=$page&page_size=5'),
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return FeedModel.fromJson(data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
