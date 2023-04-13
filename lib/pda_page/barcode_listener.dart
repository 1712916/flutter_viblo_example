import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

class BarcodeListenerPage extends StatefulWidget {
  const BarcodeListenerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeListenerPage> createState() => _BarcodeListenerPageState();
}

class _BarcodeListenerPageState extends State<BarcodeListenerPage> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                children: [
                  TextField(),
                ],
              );
            },
          ).then((value) {
            FocusManager.instance.primaryFocus?.previousFocus();
          });
        },
      ),
      body: Column(
        children: [
          BarcodeKeyboardListener(
            child: Text('Code: \n$code'),
            onBarcodeScanned: (code) {
              this.code = code;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
