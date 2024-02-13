import 'dart:io';

class AdHelper {
  static String homepageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-7545067394669786/5948240298";
    } else {
      return '';
    }
  }
}
