import 'dart:async';
import 'dart:io';
import 'package:konnect/QRPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:konnect/screens/homepage.dart';
import 'allUtilities.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await storage.write(key: "login_status",value: null);


  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
    theme: ThemeData(
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Colors.white
        ))
      )
    ),
      home: const Homepage()
  ));
}

// package_info_plus: ^3.1.0
// flutter_inappwebview: ^5.7.2+3
// qr_flutter: ^4.0.0
// flutter_secure_storage: ^6.0.0
// bloc: ^8.1.0
// flutter_bloc: ^8.1.1
// equatable: ^2.0.5
// blur: ^3.1.0
// flutter_spinkit: ^5.1.0
// qr_code_scanner: ^1.0.1
// permission_handler: ^10.0.1
// mailer: ^5.2.0
// path_provider: ^2.0.11
