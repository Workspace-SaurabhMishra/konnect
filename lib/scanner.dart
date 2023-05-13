import 'dart:convert';
import 'dart:io';
import 'package:konnect/allUtilities.dart';
import 'package:konnect/bloc/login/login_bloc.dart';
import 'package:konnect/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  Barcode? qrData;

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await qrController!.pauseCamera();
    }
  }

  void onQRViewCreated(controller) {
    setState(() {
      qrController = controller;
    });

    qrController?.scannedDataStream.listen((data) async {
      dynamic decodeData = json.decode(data.code.toString());
      String receiverLinkedInUrl = decodeData["urn"]; //todo: replace with urn
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return CustomWebView(sourceLink: receiverLinkedInUrl);
      }));
      qrController!.pauseCamera();
      Future.delayed(const Duration(seconds: 2),() => qrController!.resumeCamera());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
