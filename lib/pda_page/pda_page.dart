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

  @override
  void dispose() {
    codeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDAWidget(
        onChanged: (code) {
          codeNotifier.value = code;
        },
        onNotFound: () {
          codeNotifier.value = 'not found';
        },
        child: ValueListenableBuilder<String>(
          valueListenable: codeNotifier,
          builder: (context, value, child) {
            return Center(child: Text('Code: \n$value'));
          },
        ),
      ),
    );
  }
}

class PDAWidget extends StatefulWidget {
  const PDAWidget({Key? key, this.onChanged, this.onNotFound, this.child}) : super(key: key);

  final ValueChanged<String>? onChanged;
  final VoidCallback? onNotFound;
  final Widget? child;

  @override
  State<PDAWidget> createState() => _PDAWidgetState();
}

class _PDAWidgetState extends State<PDAWidget> {
  static const String _notFound = '404_PDA_SCAN_NOT_FOUND';

  final BehaviorSubject<String> _subject = BehaviorSubject();

  late final StreamSubscription _streamSubscription;

  final FocusNode focusNode = FocusNode();

  final StringBuffer _chars = StringBuffer();

  @override
  void initState() {
    super.initState();
    _streamSubscription = _subject.stream.debounceTime(const Duration(milliseconds: 100)).listen((code) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKeyEvent: (KeyEvent event) {
        switch (event.runtimeType) {
          case KeyDownEvent:
            {
              if (event.logicalKey.keyLabel.length == 1) {
                _chars.write(event.logicalKey.keyLabel.characters.first);
                _subject.add(_chars.toString());
              }
              return;
            }
          case KeyUpEvent:
            {
              switch (event.logicalKey.keyLabel.toUpperCase()) {
                case 'F12':
                  {
                    _subject.add(_notFound);
                    return;
                  }
                case 'ENTER':
                  {
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
