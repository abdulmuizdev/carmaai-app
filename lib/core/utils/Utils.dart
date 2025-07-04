import 'package:audioplayers/audioplayers.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../constants/secrets.dart';

class Utils {
  // static AudioPlayer audioPlayer = AudioPlayer();

  static String dateFormat = 'dd-MMM-yy';

  static void initializeSuperWall(VoidCallback onConfigured) async {
    String superWallApiKey =
        Secrets.superWallApiKey;
    Superwall.logging.level = LogLevel.info;
    Superwall.configure(superWallApiKey,
        completion: onConfigured,
        purchaseController: locator<SubscriptionController>());

    await locator<SubscriptionController>().syncSubscriptionStatus();
  }

  static void playSound(String sound) {
    try {
      final isSoundEnabled =
          locator<SharedPreferences>().getBool(Constants.SOUND_EFFECTS_SP_KEY);
      if (isSoundEnabled ?? true) {
        AudioPlayer audioPlayer = AudioPlayer();
        audioPlayer.play(AssetSource(sound));
      }
    } catch (e) {
      print(e);
    }
  }

  static void sendHaptic(HapticsType type) async {
    final canVibrate = await Haptics.canVibrate();
    // print('can vibrate is this');
    print(canVibrate);
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.heavy);
    }
  }

  static String? formatNumber(String input) {
    // Validate and parse the input string into a double
    double number;
    try {
      number = double.parse(input);
    } catch (e) {
      return null;
    }

    // Check if the number is NaN or Infinite
    if (number.isNaN || number.isInfinite) {
      return null;
    }

    // Format the number with commas for thousands
    final formatter = NumberFormat("#,##0", "en_US");

    // Check if the number has decimal places
    if (number == number.toInt()) {
      // If no decimal part, use the formatter without decimals and add the dollar symbol
      return "${formatter.format(number)}";
    } else {
      // If decimal part exists, format with 2 decimal places and add the dollar symbol
      final decimalFormatter = NumberFormat("#,##0.00", "en_US");
      return "${decimalFormatter.format(number)}";
    }
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd-MMM-yy');
    return dateFormatter.format(now);
  }

  static String getFirstOfCurrentMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final dateFormatter = DateFormat('dd-MMM-yy');
    return dateFormatter.format(firstDayOfMonth);
  }

  static String getLastOfCurrentMonth() {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final dateFormatter = DateFormat('dd-MMM-yy');
    return dateFormatter.format(lastDayOfMonth);
  }

  static String getCurrentMonthForDashboard() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('MMM yy');
    return dateFormatter.format(now);
  }

  static String getCurrentMonth({bool? showYear}) {
    final now = DateTime.now();
    final dateFormatter = DateFormat((showYear ?? false) ? 'MMM yy' : 'MMM');
    return dateFormatter.format(now);
  }

  static String getCurrentYear() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy');
    return dateFormatter.format(now);
  }

  static String getCurrentTime() {
    final now = DateTime.now();
    final timeFormatter = DateFormat('hh:mm a');
    return timeFormatter.format(now);
  }

  static String getFirstDateOfMonth(String monthAbbreviation, String year) {
    return '1-$monthAbbreviation-${year.substring(2)}';
  }

  static String getLastDateOfMonth(String monthAbbreviation, String year) {
    // Map for month abbreviation to month number
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };

    // Get the month number from abbreviation
    int month = months[monthAbbreviation] ?? 1;

    //TODO: do something for tryParse
    // Get the last day of the month by creating a DateTime object for the next month and going back one day
    DateTime firstDayOfNextMonth = DateTime(int.parse(year), month + 1, 1);
    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));

    // Format the date as required
    return '${lastDayOfMonth.day}-$monthAbbreviation-${year.substring(2)}';
  }

  static String convertFromIso8601(String isoDateString) {
    try {
      // Parse the ISO8601 string into a DateTime object
      DateTime date = DateTime.parse(isoDateString);

      // Define the output format (e.g., '1-Jan-24')
      DateFormat outputFormat = DateFormat('dd-MMM-yy');

      // Format the DateTime object into the custom format
      return outputFormat.format(date);
    } catch (e) {
      // Return an empty string or handle the error appropriately
      return '';
    }
  }

  static String convertToIso8601(String dateString) {
    try {
      // Define the input format (e.g., '1-Jan-24')
      DateFormat inputFormat = DateFormat('dd-MMM-yy');

      // Parse the date string into a DateTime object
      DateTime date = inputFormat.parse(dateString);

      // Convert DateTime to ISO8601 format string
      return date.toIso8601String(); // e.g., '2024-01-01T00:00:00.000'
    } catch (e) {
      // Return an empty string or handle the error appropriately
      return '';
    }
  }

  static Route createRoute(Widget widget) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static List<String> YEARS() {
    int offset = 20;
    int currentYear = DateTime.now().year;
    List<int> years = [];

    // Add years from current year - offset to current year + offset
    for (int i = -offset; i <= offset; i++) {
      years.add(currentYear + i);
    }

    return years.map((year) => year.toString()).toList();
  }
}
