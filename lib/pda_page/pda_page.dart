import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PDAPage extends StatefulWidget {
  const PDAPage({Key? key}) : super(key: key);

  @override
  State<PDAPage> createState() => _PDAPageState();
}

class _PDAPageState extends State<PDAPage> {
  final FocusNode focusNode = FocusNode();

  String _chars = '';

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    return Scaffold(
      appBar: AppBar(title: Text('PDA')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _chars = '';
          setState(() {});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RawKeyboardListener(
                autofocus: true,
                focusNode: focusNode,
                onKey: (RawKeyEvent event) {
                  print(event.runtimeType);
                  print('event.logicalKey.keyLabel: ${event.logicalKey.keyLabel}');
                  print('event.data.keyLabel: ${event.data.keyLabel}');

                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey.keyLabel.length == 1) {
                      setState(() {
                        _chars += '${event.logicalKey.keyLabel.characters.first}';
                      });
                    }
                  } else {}
                },
                child: Text("a: ${_chars}", style: TextStyle(fontSize: 30, color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
