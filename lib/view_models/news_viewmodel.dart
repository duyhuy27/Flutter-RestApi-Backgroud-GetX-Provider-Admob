import 'package:news_app_2/models/news_latest_model.dart';
import 'package:news_app_2/res/news_res.dart';

class NewsViewModel {
  final _rep = NewsRepository();
  Future<NewsLatestModel> fetchNewsLatest(String category) async {
    final reponse = await _rep.fetchNewsLatest(category);
    return reponse;
  }
}
