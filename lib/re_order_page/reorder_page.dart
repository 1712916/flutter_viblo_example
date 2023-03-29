import 'package:flutter/material.dart';

class ReOrderPage extends StatefulWidget {
  const ReOrderPage({Key? key}) : super(key: key);

  @override
  State<ReOrderPage> createState() => _ReOrderPageState();
}

class _ReOrderPageState extends State<ReOrderPage> {
  String text = 'Draggable and DragTarget | Drag and Drop in Flutter';

  late List<String> texts = text.split(' ')..add('___');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Wrap(
        runSpacing: 8,
        spacing: 8,
        children: List.generate(
          texts.length,
          (index) => DragTextWidget(
            text: texts[index],
            onAccept: (data) {
              texts[index] = '${texts[index]} $data';
              texts.remove(data);
              setState(() {});
            },
          ),
        ),
      ),
      // body: ReorderableWrap(
      //   runSpacing: 8,
      //   spacing: 8,
      //   onReorder: (int oldIndex, int newIndex) {
      //     setState(() {
      //       texts.insert(newIndex, texts.removeAt(oldIndex));
      //     });
      //   },
      //   children: texts
      //       .map((e) => TextChip(
      //             text: e,
      //     color: e == '___' ? Colors.cyan.shade200 : null,
      //           ))
      //       .toList(),
      //   buildDraggableFeedback: (context, constraints, child) {
      //     return child;
      //   },
      // ),
    );
  }
}

class DragTextWidget extends StatefulWidget {
  const DragTextWidget({Key? key, required this.text, this.onAccept}) : super(key: key);
  final String text;
  final ValueChanged<String>? onAccept;

  @override
  State<DragTextWidget> createState() => _DragTextWidgetState();
}

class _DragTextWidgetState extends State<DragTextWidget> {
  bool isSelect = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelect = !isSelect;
        setState(() {});
      },
      child: Draggable(
        data: widget.text,
        feedback: Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            child: TextChip(
              text: widget.text,
              color: Colors.cyanAccent.withOpacity(0.1),
            )),
        child: DragTarget(
          onAccept: (String data) {
            if (data == widget.text) {
              return;
            }
            widget.onAccept?.call(data);
          },
          builder: (_, __, ___) => TextChip(
            text: widget.text,
            color: isSelect ? Colors.cyan : null,
          ),
        ),
      ),
    );
  }
}

class TextChip extends StatelessWidget {
  const TextChip({Key? key, required this.text, this.color}) : super(key: key);
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.grey.shade400.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text),
      ),
    );
  }
}
