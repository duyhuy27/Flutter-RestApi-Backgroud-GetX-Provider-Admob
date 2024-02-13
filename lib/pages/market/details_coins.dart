// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:news_app_2/models/coin_market_model.dart';

import '../../controller/crypto_chart_controller.dart';
import '../../models/chart/chart_data.dart';
import '../../models/chart/chart_data_candle.dart';

class CryptoChartPage extends StatelessWidget {
  final MarketCapModel coinModel;

  CryptoChartPage({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final aspectRatio = screenWidth / screenHeight;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: GetBuilder<CryptoChartController>(
          init: CryptoChartController(coinId: coinModel.id),
          builder: (controller) {
            return Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: controller.isLineChart.value
                            ? _buildLineChart(controller.chartData)
                            : _buildCandlestickChart(
                                controller.chartDataCandle),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.switchChartType();
                      },
                      child: Text(controller.isLineChart.value
                          ? 'Switch to Candlestick'
                          : 'Switch to Line Chart'),
                    ),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.text.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                controller.textBool.assignAll(List.filled(
                                    controller.textBool.length, false));
                                controller.textBool[index] = true;
                                controller.setDays(controller.text[index]);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: controller.textBool[index]
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  controller.text[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildLineChart(RxList<ChartData> chartData) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <CartesianSeries>[
        LineSeries<ChartData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.price,
        )
      ],
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: InteractiveTooltip(
          format: 'point.x : point.y',
        ),
      ),
    );
  }

  Widget _buildCandlestickChart(RxList<ChartDataCandle> chartDataCandle) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(isVisible: false), // Hide X-axis
      series: <CartesianSeries>[
        CandleSeries<ChartDataCandle, DateTime>(
          dataSource: chartDataCandle,
          xValueMapper: (ChartDataCandle data, _) => data.x,
          lowValueMapper: (ChartDataCandle data, _) => data.l,
          highValueMapper: (ChartDataCandle data, _) => data.h,
          openValueMapper: (ChartDataCandle data, _) => data.o,
          closeValueMapper: (ChartDataCandle data, _) => data.c,
          borderWidth: 4, // Adjust size of the candlesticks
        )
      ],
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
      ),
    );
  }
}
