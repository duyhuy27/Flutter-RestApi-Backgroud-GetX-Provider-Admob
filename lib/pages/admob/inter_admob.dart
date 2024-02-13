import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterAdScreen extends StatefulWidget {
  const InterAdScreen({super.key});

  @override
  State<InterAdScreen> createState() => _InterAdScreenState();
}

class _InterAdScreenState extends State<InterAdScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initInterAd();
  }

  late InterstitialAd interstitialAd;
  bool isAdloaded = false;
  var unitId = "ca-app-pub-7545067394669786/6284934605";

  initInterAd() {
    InterstitialAd.load(
      adUnitId: unitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interstitialAd = ad;
        setState(() {
          isAdloaded = true;
          interstitialAd.show();
        });
        interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();

            setState(() {
              isAdloaded = false;
            });

            print('ad is dissmed');
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            setState(() {
              isAdloaded = false;
            });
          },
        );
      }, onAdFailedToLoad: (error) {
        print(error.toString());
        interstitialAd.dispose();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inter ad'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              if (isAdloaded) {
                interstitialAd.show();
              }
            },
            child: Text('Task completed')),
      ),
    );
  }
}
