import 'package:in_app_review/in_app_review.dart';

class RateAppService {
  static final InAppReview _inAppReview = InAppReview.instance;

  /// Function to trigger the rate app prompt
  static Future<void> rateApp() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview(); // Shows the in-app review prompt
    } else {
      // If not available, open the App Store review page
      _inAppReview.openStoreListing(
        appStoreId: '6741025552', // Replace with your App Store ID
      );
    }
  }
}
