import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app_2/pages/admob/ad_helper/ad_provider.dart';
import 'package:news_app_2/pages/admob/admob_screen_test.dart';
import 'package:news_app_2/pages/home.dart';
import 'package:news_app_2/pages/market/market_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => AdProvider()), // Provide AdProvider here
        ],
        child: MakeScreen(), // Your AdmobScreen widget
      ),
    );
  }
}
