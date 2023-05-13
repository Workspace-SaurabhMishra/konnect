import 'dart:convert';
import 'dart:typed_data';
import 'package:konnect/allUtilities.dart';
import 'package:konnect/bloc/login/login_bloc.dart';
import 'package:konnect/login.dart';
import 'package:konnect/scanner.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

@immutable
class QRPage extends StatelessWidget {

  QRPage({Key? key}) : super(key: key);

  void cameraAccess() async {
    while (Permission.camera.status != true) {
      await Permission.camera.request();
    }
  }

  void initState() {
    cameraAccess();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc()..add(IsLoggedInEvent()),
      child: Stack(
        children: [
          Center(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoggedInState) {
                  return Card(
                    elevation: 20,
                    shadowColor: Colors.white,
                    child: QrImage(
                      data: state.qrData,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.7,
                      gapless: true,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(80, 80),
                      ),
                    ),
                  );
                } else if (state is ShowAppLinkQrState) {
                  return Card(
                    elevation: 20,
                    shadowColor: Colors.white,
                    child: QrImage(
                      data: state.appLink,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.7,
                      gapless: true,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(80, 80),
                      ),
                    ),
                  );
                } else {
                  return Blur(
                    blur: 5,
                    blurColor: Colors.black26,
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.white,
                      child: QrImage(
                        data:
                        " Lorem Ipsum has been the industry's standard dummy publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.width * 0.7,
                        gapless: true,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(80, 80),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is NewLogInState) {
                return Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(65, 1, 590, 10)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const Login(
                                  sourceLink: "https://linkedin.com/login");
                            }));
                      },
                      child: const Text("Login to Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ));
              } else {
                return const Center(
                  child: Text(""),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
