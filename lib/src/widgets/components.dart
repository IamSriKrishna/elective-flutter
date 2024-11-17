import 'package:elective/src/app/app_family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Components {
  static const regularFontFamily = AppFamily.regular;
  static Widget openSansText(
      {String text = "",
      FontStyle fontStyle = FontStyle.normal,
      Color? color = Colors.black,
      String fontFamily = regularFontFamily,
      TextAlign textAlign = TextAlign.center,
      FontWeight fontWeight = FontWeight.normal,
      double fontSize = 14}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight),
    );
  }

  static Future<dynamic> instuctor(BuildContext context, String text) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Instruction"),
          content: openSansText(text: text),
          actions: [
            CupertinoDialogAction(
              child: openSansText(text: "Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> confirmBook(BuildContext context,
      {required void Function() onPressed}) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Warning",
              color: Colors.red),
          content: openSansText(
              text: "Are You Sure Do You Want To Select This Elective???"),
          actions: [
            CupertinoDialogAction(
              onPressed: onPressed,
              child: openSansText(text: "Yes"),
            ),
            CupertinoDialogAction(
              child: openSansText(text: "No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> noMoreSeat(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Warning!!!"),
          content: openSansText(text: "You Cannot Select More Than One Course"),
          actions: [
            CupertinoDialogAction(
              child: openSansText(text: "Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> oneSeat(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Warning!!!"),
          content: openSansText(text: "You Cannot Select More Than One Seat"),
          actions: [
            CupertinoDialogAction(
              child: openSansText(text: "Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> waitTillNov(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Warning!!!"),
          content: openSansText(
              text:
                  "Please wait until 7:00 PM on 20th November 2024, or the link is no longer available after 11:00 PM."),
          actions: [
            CupertinoDialogAction(
              child: openSansText(text: "Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> sessionExpired(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: openSansText(
              fontFamily: AppFamily.bold,
              fontWeight: FontWeight.bold,
              text: "Session Expired"),
          content: openSansText(
              text:
                  "Your session has expired. Unfortunately, there is no more time left."),
          actions: [
            CupertinoDialogAction(
              child: openSansText(text: "Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error(
      BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white, // Use a white color for the error icon
              size: 24.0,
            ),
            const SizedBox(width: 10), // Add some spacing between icon and text
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white, // Set text color to white for contrast
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor:
            Colors.redAccent, // A bright red background for the error
        behavior: SnackBarBehavior
            .fixed, // Optional: Fixed at the bottom of the screen
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        elevation: 6.0, // Add shadow effect to make it pop
        duration: const Duration(
            seconds: 4), // You can adjust the duration to your needs
      ),
    );
  }

  static Logger log = Logger();
  static void logMessage(String message) {
    return log.d("🏆🏆🏆 $message 🏆🏆🏆");
  }

  static void logErrorMessage(String warning, Object details) {
    return log.e("⚠️⚠️⚠️ $warning ⚠️⚠️⚠️", error: details);
  }
}
