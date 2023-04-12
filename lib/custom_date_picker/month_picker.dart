import 'package:flutter/material.dart';

class MonthPicker extends StatefulWidget {
  MonthPicker({Key? key, this.initMonth, this.startMonth, this.endMonth}) : super(key: key) {
    if (initMonth != null) {
      assert(initMonth! > 0, 'widget.initMonth must [1,12]');
      assert(initMonth! <= 12, 'widget.initMonth must [1,12]');
    }

    if (startMonth != null) {
      assert(startMonth! > 0, 'widget.startMonth must [1,12]');
      assert(startMonth! <= 12, 'widget.startMonth must [1,12]');
    }

    if (endMonth != null) {
      assert(endMonth! > 0, 'widget.endMonth must [1,12]');
      assert(endMonth! <= 12, 'widget.endMonth must [1,12]');
    }

    if (startMonth != null && endMonth != null) {
      assert(startMonth! < endMonth!, 'startMonth must < endMonth');
      assert(startMonth! < endMonth!, 'startMonth must < endMonth');
      if (initMonth != null) {
        assert(startMonth! <= initMonth! && endMonth! >= initMonth!, 'selectMonth is between startMonth and endMonth');
      }
    }
  }

  final int? initMonth;
  final int? startMonth;
  final int? endMonth;

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

  bool isEnable(int m) {
    if (widget.startMonth != null) {
      if (widget.startMonth! > m) {
        return false;
      }
    }

    if (widget.endMonth != null) {
      if (widget.endMonth! < m) {
        return false;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (widget.initMonth != null) {
      selectMonth = widget.initMonth! - 1;
    }
  }

  @override
  void didUpdateWidget(covariant MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startMonth != widget.startMonth ||
        oldWidget.endMonth != widget.endMonth ||
        oldWidget.initMonth != widget.initMonth) {
      init();
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
                      (index) {
                        return GestureDetector(
                          onTap: isEnable(index + 1) ? () => onTap(index) : null,
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
                        );
                      },
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

  void onTap(int index) {
    selectMonth = index;
    setState(() {});
  }
}
