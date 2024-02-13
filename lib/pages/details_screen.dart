// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:news_app_2/pages/my_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsNews extends StatefulWidget {
  String url;
  DetailsNews({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<DetailsNews> createState() => _DetailsNewsState();
}

class _DetailsNewsState extends State<DetailsNews> {
  WebViewController controller = WebViewController();
  var loadingPercentage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.share)),
            IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more)),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100,
              )
          ],
        ));
  }
}
