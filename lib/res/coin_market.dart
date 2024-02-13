import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_2/models/coin_market_model.dart';

class CoinMarketRepository {
  Future<List<MarketCapModel>> fetchCoinMarket() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1h&locale=en'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<MarketCapModel> marketCapList =
            jsonData.map((item) => MarketCapModel.fromJson(item)).toList();
        return marketCapList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching coin market data: $e');
    }
  }
}
