import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:news_app_2/models/coin_market_model.dart';

class CoinController extends GetxController {
  RxList<MarketCapModel> coinList = <MarketCapModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoinMarket();
  }

  fetchCoinMarket() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1h&locale=en'));
      if (response.statusCode == 200) {
        List<MarketCapModel> coins = marketCapModelFromJson(response.body);
        coinList.value = coins;
      } else if (response.statusCode == 429) {
        print("loi mat rui");
      }
    } finally {
      isLoading(false);
    }
  }
}
