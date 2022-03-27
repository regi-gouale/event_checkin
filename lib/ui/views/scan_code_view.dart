import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanCodeView extends StatefulWidget {
  const ScanCodeView({Key? key, required this.eventID}) : super(key: key);
  final String eventID;

  @override
  State<ScanCodeView> createState() => _ScanCodeViewState();
}

class _ScanCodeViewState extends State<ScanCodeView> {
  Barcode qrCodeResult = Barcode(
    null,
    BarcodeFormat.dataMatrix,
    null,
  );

  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Color qrColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildQrView(context),
            flex: 5,
          ),
          Expanded(
            child: _colorCameraInterface(qrCodeResult),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _buildQrView(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width * 0.8;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: qrColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, permission) => _onPermissionSet(
        context,
        ctrl,
        permission,
      ),
    );
  }

  void _onQRViewCreated(QRViewController ctrl) {
    setState(() {
      controller = ctrl;
    });
    controller.scannedDataStream.listen((data) async{
      setState(() {
        qrCodeResult = data;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool permission,
  ) {
    // if (permission) {
    //   controller = ctrl;
    //   controller.scannedDataStream.listen(_onQRViewScanned);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Camera permission denied'),
    //       action: SnackBarAction(
    //         label: 'Ok',
    //         onPressed: () {
    //           controller.resumeCamera();
    //         },
    //       ),
    //     ),
    //   );
    // }

    if (!permission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Camera permission denied'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              controller.resumeCamera();
            },
          ),
        ),
      );
    }
  }

  Widget _colorCameraInterface(Barcode barcode) {
    setState(() {
      qrColor = Colors.red;
    });

    if (barcode.format == BarcodeFormat.qrcode &&
        (barcode.code != "" || barcode.code != null)) {
      FirebaseFirestore.instance
          .collection("persons")
          .doc(barcode.code)
          .get()
          .then((person) {
        if (person.exists) {
          print(person.data());
          FirebaseFirestore.instance
              .collection("events")
              .doc(widget.eventID)
              .collection("attendees")
              .doc(person.id)
              .set({
            "firstName": person.data()!["firstName"],
            "lastName": person.data()!["lastName"],
            "email": person.data()!["email"],
            "phone": person.data()!["phone"],
            "birthYear": person.data()!["birthYear"],
            "gender": person.data()!["gender"],
          });
        } else {
          print("No such document!");
        }
      });
    }

    return Container(
      color: qrColor,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'format: ${barcode.format.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'code: ${barcode.code ?? ""}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
