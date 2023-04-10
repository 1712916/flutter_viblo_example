import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class PDAPage extends StatefulWidget {
  const PDAPage({Key? key}) : super(key: key);

  @override
  State<PDAPage> createState() => _PDAPageState();
}

class _PDAPageState extends State<PDAPage> {
  final ValueNotifier<String> codeNotifier = ValueNotifier('');

  FocusNode? focusNode;

  @override
  void dispose() {
    codeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //hide keyboard
        //FocusManager.instance.primaryFocus?.unfocus();

        //re focus to pda input
        focusNode?.requestFocus();
      },
      child: Scaffold(
        body: PDAWidget(
          getFocusNode: (f) {
            focusNode = f;
          },
          onChanged: (code) {
            codeNotifier.value = code;
          },
          onNotFound: () {
            codeNotifier.value = 'not found';
          },
          child: ValueListenableBuilder<String>(
            valueListenable: codeNotifier,
            builder: (context, value, child) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Code: \n$value'),
                  //*add textfield here will hard to handle scan by pda
                  //TextField(),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}

/*
* Test Device: AUTOID Q9
*
* It can listen for events from other physical keyboard.
*
* Slow performance with long code. Recommend length less than 20.
*
* */
class PDAWidget extends StatefulWidget {
  const PDAWidget({
    Key? key,
    this.onChanged,
    this.onNotFound,
    this.child,
    this.getFocusNode,
  }) : super(key: key);

  ///listen barcode change
  final ValueChanged<String>? onChanged;

  ///listen barcode not found
  final VoidCallback? onNotFound;

  ///limit use of TextField
  final Widget? child;

  ///get focus node to handle from external
  final Function(FocusNode focusNode)? getFocusNode;

  @override
  State<PDAWidget> createState() => _PDAWidgetState();
}

class _PDAWidgetState extends State<PDAWidget> {
  static const String _notFound = '404_PDA_SCAN_NOT_FOUND';

  static const String _startScanLabelKey = 'F12';

  static const String _endScanLabelKey = 'ENTER';

  final BehaviorSubject<String> _subject = BehaviorSubject();

  late final StreamSubscription _streamSubscription;

  final FocusNode _focusNode = FocusNode();

  final StringBuffer _chars = StringBuffer();

  @override
  void initState() {
    super.initState();

    widget.getFocusNode?.call(_focusNode);

    _streamSubscription = _subject.stream.debounceTime(const Duration(milliseconds: 50)).listen((code) {
      if (code == _notFound) {
        log('[PDA SCAN LOG]: $_notFound');
        widget.onNotFound?.call();
      } else {
        log('[PDA SCAN LOG]: $code');
        widget.onChanged?.call(code);
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _subject.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //focus here to ensure KeyboardListener is focus
    _focusNode.requestFocus();
    return KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        switch (event.runtimeType) {
          case KeyDownEvent:
            {
              if (event.logicalKey.keyLabel.length == 1) {
                if (event.character?.isNotEmpty ?? false) {
                  //return pure key
                  _chars.write(event.character![0]);
                } else {
                  //return a upper key
                  _chars.write(event.logicalKey.keyLabel.characters.first);
                }
                _subject.add(_chars.toString());
              }
              return;
            }
          case KeyUpEvent:
            {
              switch (event.logicalKey.keyLabel.toUpperCase()) {
                case _startScanLabelKey:
                  {
                    //add not found event
                    _subject.add(_notFound);
                    return;
                  }
                case _endScanLabelKey:
                  {
                    //clear _chars temporary
                    _chars.clear();
                    return;
                  }
              }
            }
        }
      },
      child: widget.child ?? const SizedBox(),
    );
  }
}
