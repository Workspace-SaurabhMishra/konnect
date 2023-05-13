import 'dart:async';
import 'dart:io';
import 'package:konnect/QRPage.dart';
import 'package:konnect/allUtilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:konnect/screens/homepage.dart';

class FetchDetails extends StatefulWidget {
  const FetchDetails({Key? key}) : super(key: key);

  @override
  _FetchDetailsState createState() => _FetchDetailsState();
}

class _FetchDetailsState extends State<FetchDetails> {
  late HeadlessInAppWebView headlessWebView;
  String url1 = "";
  String url2 = "";
  double progress = 0;
  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptCanOpenWindowsAutomatically: true,
        userAgent: "random",
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ));
  bool finishingValue = false;

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  @override
  void initState(){
    super.initState();
    // pullToRefreshController = PullToRefreshController(
    //   options: PullToRefreshOptions(
    //     color: Colors.blue,
    //   ),
    //   onRefresh: () async {
    //     if (Platform.isAndroid) {
    //       webViewController.reload();
    //     } else if (Platform.isIOS) {
    //       webViewController.loadUrl(
    //           urlRequest: URLRequest(url: await webViewController.getUrl()));
    //     }
    //   },
    // );

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        //todo: no need of email fetching, so replace email url to photo or email url
          url: Uri.parse(
              "https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=false")),
      initialOptions: options,
      // pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onCreateWindow: (controller, createWindowAction) async {

        showDialog(
          context: context,
          builder: (context) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: InAppWebView(
                    // Setting the windowId property is important here!
                    windowId: createWindowAction.windowId,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptCanOpenWindowsAutomatically: true,
                        javaScriptEnabled: true,
                        userAgent: "random",
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
        headlessWebView.dispose();
        headlessWebView.run();
        return true;
      },
      onLoadStart: (controller, url) {
        setState(() {
          // url1 = url.toString();
          urlController.text = url.toString();
        });
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
            .contains(uri.scheme)) {
        }

        return NavigationActionPolicy.ALLOW;
      },
      onProgressChanged: (controller, progress) async {
        if (urlController.text ==
                "https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=false" &&
            progress == 100) {
          webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      "https://www.linkedin.com/public-profile/settings?trk=d_flagship3_profile_self_view_public_profile")));
          Future.delayed(const Duration(seconds: 1), () async {
            var urn = await webViewController.evaluateJavascript(
                source:
                    '''document.querySelector('#vanityUrlForm').value;''');
            await storage.write(
                key: "login_urn", value: "https://www.linkedin.com/in/$urn");

            if (storage.read(key: "login_urn") != null &&
                storage.read(key: "login_email") != null) {
              storage.write(key: "login_status",value: "true");
              headlessWebView.dispose();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                return Homepage();
              }),(context) => false);
            }
          });
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        // setState(() {
        //   url1 = url.toString();
        //   urlController.text = url1;
        // });
      },
      onConsoleMessage: (controller, consoleMessage) {
      },
    )..dispose()..run();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 31, 10),
                        Color.fromRGBO(65, 1, 590, 10)
                      ],
                    )),
                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                SizedBox(
                                  height: 200,
                                  child: SpinKitRipple(
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Just Some More Time",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w200
                                  ),
                                ),
                          ]),
                  ));
  }
}
