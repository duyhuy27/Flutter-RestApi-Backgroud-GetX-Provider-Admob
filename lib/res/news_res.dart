import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_app_2/models/news_latest_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<NewsLatestModel> fetchNewsLatest(String category) async {
    String url = 'https://min-api.cryptocompare.com/data/v2/news/?categories=$category&lang=EN';
    final reponse = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(reponse.body);
    }
    if (reponse.statusCode == 200) {
      final body = jsonDecode(reponse.body);
      return NewsLatestModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
