import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app_2/controller/coin_controller.dart';
import 'package:news_app_2/pages/market/details_coins.dart';

class MakeScreen extends StatefulWidget {
  const MakeScreen({Key? key}) : super(key: key);

  @override
  State<MakeScreen> createState() => _MakeScreenState();
}

class _MakeScreenState extends State<MakeScreen> {
  final CoinController coinController = Get.put(CoinController());

  String formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'en', symbol: '\$');
    return formatter.format(price);
  }

  String formatPercentage(double percentage) {
    final formattedPercentage = percentage.toStringAsFixed(1);
    return '${formattedPercentage} %';
  }

  String formatMarketCap(int marketCap) {
    final formattedMarketCap = (marketCap / 1000000000).toStringAsFixed(2);
    return '\$$formattedMarketCap B';
  }

  Future<void> _refresh() async {
    await coinController.fetchCoinMarket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Cap'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: RefreshIndicator(
          backgroundColor: Colors.grey, // Màu nền của RefreshIndicator
          color: Colors.blue, // Màu của vòng tròn quay
          displacement:
              40, // Khoảng cách mà vòng tròn quay xuất hiện từ đỉnh của ListView khi đang làm mới
          strokeWidth: 2, // Độ dày của vòng tròn quay
          triggerMode: RefreshIndicatorTriggerMode
              .anywhere, // Chế độ kích hoạt làm mới (anywhere hoặc onEdge)
          edgeOffset:
              100, // Khoảng cách từ đỉnh của ListView đến lúc kích hoạt làm mới
          onRefresh: _refresh, // Hàm được gọi khi làm mới được kích hoạt
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                    // Your header widgets
                    ),
                Obx(() {
                  final isLoading = coinController.isLoading.value;
                  final coinList = coinController.coinList;
                  return isLoading
                      ?const  Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: coinList.length,
                          itemBuilder: (context, index) {
                            final coins = coinList[index];
                            final isPlus =
                                coins.priceChangePercentage1HInCurrency > 0;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CryptoChartPage( coinModel : coins),
                                    ));
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                child: Image.network(
                                                  coins.image,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coins.symbol.toUpperCase(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    coins.name,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                formatPercentage(coins
                                                    .priceChangePercentage1HInCurrency
                                                    .toDouble()),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isPlus
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                formatCurrency(
                                                  coins.currentPrice.toDouble(),
                                                ),
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Vol (24h) : ${formatMarketCap(coins.totalVolume)}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            'Market Cap: : ${formatMarketCap(coins.marketCap)}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
