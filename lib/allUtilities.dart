import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const storage = FlutterSecureStorage();

SendEmail(receiverEmail,receiverLinkedInurl) async{
  String username = 'saurabh9759mishra@gmail.com';
  String password = 'qrqbdrjmhnnonhul'; //Must use G_Oauth.

  String? senderLinkedInUrl = await storage.read(key: "urn");

  final smtpServer = gmail(username,password);
  final receiversMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(receiverEmail)
    ..subject = 'Scanned Alert! ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>Your LinkedIn profile has been visited by $senderLinkedInUrl through Matrix App</p>";

  final sendersMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(await storage.read(key:"login_email"))
    ..subject = 'Scanning Alert! at ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>You have scanned Matrix QR and visted $receiverLinkedInurl</p>";

  try {
    var connection = PersistentConnection(smtpServer);

    await connection.send(receiversMessage);

    await connection.send(sendersMessage);

    await connection.close();

    return true;
  }
  on MailerException catch (e) {
    return false;
  }
}


String generateRandomUserAgent() {
  final version = Random().nextInt(100);
  final build = Random().nextInt(10000);
  final chromeVersion = '87.0.${Random().nextInt(10000)}.0';
  final androidVersion = 'Android ${Random().nextInt(10) + 28}';
  final model = 'SM-G${Random().nextInt(10)}${Random().nextInt(10)}${Random().nextInt(10)}U1';
  return 'Mozilla/5.0 ($androidVersion; Mobile; ${model}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${chromeVersion} Mobile Safari/537.36';
}

// String generateRandomUserAgent() {
//   final osVersions = ['9', '10', '11', '12']; // Supported Android SDK versions
//   final appVersions = ['1.0.0', '1.0.1', '1.1.0', '2.0.0']; // Example app versions
//
//   final random = Random();
//
//   // Randomly select an Android SDK version and app version
//   final osVersion = osVersions[random.nextInt(osVersions.length)];
//   final appVersion = appVersions[random.nextInt(appVersions.length)];
//
//   // Build the user agent string
//   return 'Mozilla/5.0 (Linux; Android $osVersion; Mobile; rv:68.0) Gecko/68.0 Firefox/68.0 MyApp/$appVersion';
// }
//
//
//
//
