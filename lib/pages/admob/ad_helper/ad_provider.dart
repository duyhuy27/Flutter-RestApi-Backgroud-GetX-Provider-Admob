import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app_2/pages/admob/ad_helper/ad_helper.dart';

class AdProvider with ChangeNotifier {
  late BannerAd homePageBanner;
  bool isHomePageBannerLoad = false;

  void initHomePageBanner() async {
    homePageBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.homepageBanner(),
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              print("Banner loaded");
              isHomePageBannerLoad = true;
            },
            onAdClosed: (ad) {
              ad.dispose();
              isHomePageBannerLoad = false;
            },
          onAdFailedToLoad: (ad,error) {
              print(error.toString());
              isHomePageBannerLoad = false;
          }
        ),
        request: AdRequest());
      await homePageBanner.load();
      notifyListeners();
  }
}
