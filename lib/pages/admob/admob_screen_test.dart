import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app_2/pages/admob/ad_helper/ad_provider.dart';
import 'package:news_app_2/pages/admob/inter_admob.dart';
import 'package:provider/provider.dart';

class AdmobScreen extends StatefulWidget {
  const AdmobScreen({super.key});

  @override
  State<AdmobScreen> createState() => _AdmobScreenState();
}

class _AdmobScreenState extends State<AdmobScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAd();
  }

  late BannerAd bannerAd;
  bool isLoaded = false;
  var adUnit = "ca-app-pub-7545067394669786/5948240298";

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admob config'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InterAdScreen()));
                },
                child: Text("Inter Ad")),
          )
        ],
      ),
      bottomNavigationBar: isLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : SizedBox(),
    );
  }
}
