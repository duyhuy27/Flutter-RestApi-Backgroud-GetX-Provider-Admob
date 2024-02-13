import 'package:news_app_2/models/coin_market_model.dart';
import 'package:news_app_2/res/coin_market.dart';

class CoinsViewModel {
  final _repo = CoinMarketRepository();

  Future<List<MarketCapModel>> fetchCoinMarket() async {
    try {
      return await _repo.fetchCoinMarket();
    } catch (e) {
      throw Exception('Error fetching coin market data: $e');
    }
  }
}
