import 'package:flutter/material.dart';

class CustomYearPicker extends StatefulWidget {
  const CustomYearPicker({Key? key, this.initYear}) : super(key: key);

  final int? initYear;

  @override
  State<CustomYearPicker> createState() => _CustomYearPickerState();

  Future<int?> showCenterDialog(BuildContext context) {
    return showDialog<int?>(
      context: context,
      useRootNavigator: false,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: this,
        ),
      ),
    );
  }
}

class _CustomYearPickerState extends State<CustomYearPicker> {
  int selectYear = 0;

  final controller = ScrollController();

  final crossAxisCount = 3;

  @override
  void initState() {
    super.initState();

    if (widget.initYear != null) {
      assert(widget.initYear! >= 0, 'year must >= 0');
      selectYear = widget.initYear! - 1;
    } else {
      selectYear = DateTime.now().year - 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final itemHeight = (MediaQuery.of(context).size.width - 16) / crossAxisCount / 2;
      int rowNumber = ((selectYear + 1) / crossAxisCount).floor();

      if ((selectYear + 1) % 3 == 0) {
        controller.jumpTo((rowNumber * itemHeight) - 3 * itemHeight);
      } else {
        if (rowNumber > 3) {
          controller.jumpTo((rowNumber * itemHeight) - 2 * itemHeight);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          'Chọn năm',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: LayoutBuilder(builder: (_, c) {
                  double ratio = (c.maxWidth / 3) / (c.maxHeight / 4);
                  return GridView.builder(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 2 / 1,
                    ),
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        selectYear = index;
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selectYear == index ? Colors.greenAccent : null,
                            border: Border.fromBorderSide(
                              BorderSide(
                                  width: 0.5, color: selectYear == index ? Colors.greenAccent : Colors.grey.shade200),
                            )),
                        child: Text(
                          'Năm ${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectYear + 1);
                      },
                      child: Text('OK'))),
            ],
          ),
        ),
      ),
    );
  }
}
