import 'dart:async';
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
  void initState() {
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
          //todo: no need of email fetching, so replace email url to photo
          url: Uri.parse(
              "https://www.linkedin.com/public-profile/settings?trk=d_flagship3_profile_self_view_public_profile")),
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
            .contains(uri.scheme)) {}

        return NavigationActionPolicy.ALLOW;
      },
      onProgressChanged: (controller, progress) async {
        if (urlController.text ==
                "https://www.linkedin.com/public-profile/settings?trk=d_flagship3_profile_self_view_public_profile" &&
            progress == 100) {
          Future.delayed(const Duration(seconds: 0), () async {
            var urn = (await webViewController.evaluateJavascript(
                source: '''document.querySelector('#vanityUrlForm').value;''')).toString().trim().replaceAll("\n", "");
            await storage.write(
                key: "urn", value: "https://www.linkedin.com/in/$urn");

            var name = (await webViewController.evaluateJavascript(
                source:
                    '''document.evaluate('/html/body/main/section[1]/div/section[2]/section[1]/div/div[2]/div[1]/h1', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;''')).toString().trim().replaceAll("\n", "");
            await storage.write(key: "user_name", value: name);

            var designation = (await webViewController.evaluateJavascript(
                source:
                    '''document.querySelector('.profile-section-card__title:first-of-type').textContent;''')).toString().trim().replaceAll("\n", "");
            await storage.write(
                key: "user_designation", value: designation);

            var imageUrl = (await webViewController.evaluateJavascript(
                source:
                    '''document.evaluate('/html/body/main/section[1]/div/section[2]/section[1]/div/div[1]/img[1]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.getAttribute('src');''')).toString().trim().replaceAll("\n", "");

            await storage.write(key: "user_image_url", value: imageUrl);

            var follower = (await webViewController.evaluateJavascript(
                source:
                '''document.evaluate('/html/body/main/section[1]/div/section[2]/section[1]/div/div[2]/div[1]/h3/span[1]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent;''')).toString().trim().replaceAll("\n", "");

            await storage.write(key: "user_follower", value: follower);

            var connection = (await webViewController.evaluateJavascript(
                source:
                '''document.evaluate('/html/body/main/section[1]/div/section[2]/section[1]/div/div[2]/div[1]/h3/span[2]/text()', document, null, XPathResult.STRING_TYPE, null).stringValue.trim();''')).toString().trim().replaceAll("\n", "");

            await storage.write(key: "user_connection", value: connection);


            if (await storage.read(key: "urn") != null &&
                await storage.read(key: "user_name") != null &&
                await storage.read(key: "user_designation") != null &&
                await storage.read(key: "user_image_url") != null
            ) {
              await storage.write(key: "login_status",value: "true");
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return Homepage();
              }), (context) => false);
            }
          });
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
      },
      onConsoleMessage: (controller, consoleMessage) {},
    )
      ..dispose()
      ..run();
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
        colors: [Color.fromRGBO(0, 0, 31, 10), Color.fromRGBO(65, 1, 590, 10)],
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
                  fontWeight: FontWeight.w200),
            ),
          ]),
    ));
  }
}
