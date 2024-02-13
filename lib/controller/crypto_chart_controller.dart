import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_2/models/coin_market_model.dart';

import '../models/chart/chart_data.dart';
import '../models/chart/chart_data_candle.dart';

class CryptoChartController extends GetxController {
  RxList<ChartData> chartData = <ChartData>[].obs;
  RxList<ChartDataCandle> chartDataCandle = <ChartDataCandle>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLineChart = true.obs;
  RxInt days = 30.obs;
  int requestCount = 0; // Thêm biến đếm yêu cầu

  CryptoChartController({required this.coinId});

  List<String> get text => ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> get textBool => [true, false, false, false, false, false];
  final String coinId;

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
    fetchChartDataCandle();
    print(coinId);
  }

  void fetchChartData() async {
    if (requestCount >= 5) {
      // Giới hạn số lần yêu cầu
      Get.snackbar('Error', 'Too many requests. Please try again later.');
      return;
    }

    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=${days.value}';
    print(coinId);

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      processChartData(data);
      requestCount++; // Tăng biến đếm sau mỗi yêu cầu thành công
    } else {
      if (response.statusCode == 429) {
        print("Error', 'API rate limit exceeded. Please try again later.");
      }
      throw Exception('Failed to load chart data');
    }
  }

  void processChartData(dynamic data) {
    final List<dynamic> prices = data['prices'];
    chartData.assignAll(prices.map((price) {
      final time = DateTime.fromMillisecondsSinceEpoch(price[0]);
      final priceValue = price[1];
      return ChartData(time, priceValue);
    }).toList());
    isLoading.value = false;
  }

  void fetchChartDataCandle() async {
    final url =
        'https://api.coingecko.com/api/v3/coins/bitcoin/ohlc?vs_currency=usd&days=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      processChartDataCandle(data);
      requestCount++; // Tăng biến đếm sau mỗi yêu cầu thành công
    } else {
      if (response.statusCode == 429) {
        print("Error', 'API rate limit exceeded. Please try again later.");
      } else {
        throw Exception('Failed to load chart data');
      }
    }
  }

  void processChartDataCandle(List<dynamic> data) {
    chartDataCandle.assignAll(data.map((candle) {
      final time = DateTime.fromMillisecondsSinceEpoch(candle[0]);
      final open = candle[1];
      final high = candle[2];
      final low = candle[3];
      final close = candle[4];

      return ChartDataCandle(time, open, high, low, close);
    }).toList());
    isLoading.value = false;
  }

  void switchChartType() {
    isLineChart.value = !isLineChart.value;
  }

  void setDays(String txt) {
    if (txt == 'D') {
      days.value = 1;
    } else if (txt == 'W') {
      days.value = 7;
    } else if (txt == 'M') {
      days.value = 30;
    } else if (txt == '3M') {
      days.value = 90;
    } else if (txt == '6M') {
      days.value = 180;
    } else if (txt == 'Y') {
      days.value = 365;
    }
    fetchChartData(); // Update chart data when days change
  }
}
