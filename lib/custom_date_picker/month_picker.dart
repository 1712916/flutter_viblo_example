import 'package:flutter/material.dart';

class MonthPicker extends StatefulWidget {
  const MonthPicker({Key? key, this.initMonth}) : super(key: key);

  final int? initMonth;

  @override
  State<MonthPicker> createState() => _MonthPickerState();

  Future<int?> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: this,
      ),
    );
  }

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

class _MonthPickerState extends State<MonthPicker> {
  int selectMonth = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initMonth != null) {
      assert(widget.initMonth! > 0, 'widget.initMonth must [1,12]');
      assert(widget.initMonth! <= 12, 'widget.initMonth must [1,12]');
      selectMonth = widget.initMonth! - 1;
    }
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
                          'Chọn tháng',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: LayoutBuilder(builder: (_, c) {
                  double ratio = (c.maxWidth / 3) / (c.maxHeight / 4);
                  return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: ratio,
                    children: List.generate(
                      12,
                      (index) => GestureDetector(
                        onTap: () {
                          selectMonth = index;
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: selectMonth == index ? Colors.greenAccent : null,
                              border: Border.fromBorderSide(
                                BorderSide(
                                    width: 0.5,
                                    color: selectMonth == index ? Colors.greenAccent : Colors.grey.shade200),
                              )),
                          child: Text(
                            'Tháng ${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                }),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectMonth + 1);
                      },
                      child: Text('OK'))),
            ],
          ),
        ),
      ),
    );
  }
}
