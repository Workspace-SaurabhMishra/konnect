import 'dart:io';
import 'package:konnect/fetchDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:konnect/screens/homepage.dart';
import 'dart:math';

import 'allUtilities.dart';

class Login extends StatefulWidget {
  final String sourceLink;

  const Login({super.key, required this.sourceLink});

  @override
  _LoginState createState() => _LoginState(sourceLink: sourceLink);
}

class _LoginState extends State<Login> {
  final String sourceLink;

  _LoginState({required this.sourceLink});

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptCanOpenWindowsAutomatically: false,
        userAgent: generateRandomUserAgent(),
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        appCachePath: "/",
        supportMultipleWindows: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleGoBack() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Homepage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        // TextField(
        //   decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
        //   controller: urlController,
        //   keyboardType: TextInputType.url,
        //   onSubmitted: (value) async {
        //     var url = Uri.parse(value);
        //     if (url.scheme.isEmpty) {
        //       url = Uri.parse("https://www.google.com/search?q=$value");
        //     }
        //     _webViewController?.loadUrl(urlRequest: URLRequest(url: url));
        //     dynamic x = await _webViewController?.getUrl();
        //   },
        // ),
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse(sourceLink)),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onCreateWindow: (controller, createWindowAction) async {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return InAppWebView(
                        // Setting the windowId property is important here!
                        windowId: createWindowAction.windowId,
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptCanOpenWindowsAutomatically: true,
                            javaScriptEnabled: true,
                            userAgent: generateRandomUserAgent(),
                          ),
                        ),
                        onWebViewCreated:
                            (InAppWebViewController controller) {},
                        onProgressChanged: (controller, progress) {},
                        onLoadStart:
                            (InAppWebViewController controller, url) {},
                        onLoadStop: (InAppWebViewController controller, url) {},
                      );
                    },
                  );

                  return true;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {}

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) async {
                  if (urlController.text == "https://www.linkedin.com/feed/") {
                    //todo: replace calling to this page
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const FetchDetails();
                    }), (context) => false);
                  }
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }

                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = url;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {},
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: handleGoBack,
                    child: const Icon(Icons.keyboard_backspace),
                  )),
            ],
          ),
        ),
      ])),
    );
  }
}
