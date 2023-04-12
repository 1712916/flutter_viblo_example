import 'package:flutter/material.dart';
import 'package:flutter_example/custom_date_picker/month_picker.dart';
import 'package:flutter_example/custom_date_picker/year_picker.dart';
import 'package:intl/intl.dart' as intl;

abstract class DateTimeFormat {
  static const String ddMMyyyy = 'dd/MM/yyyy';
  static const String dMyyyy = 'd/M/yyyy';
}

class CustomDatePickerStyle {
  final TextStyle dayStyle;
  final Color dayBackground;

  final Color dateBackground;
  final TextStyle normalStyle;
  final TextStyle nowStyle;
  final TextStyle selectDateStyle;
  final Color selectBackground;
  final TextStyle disableDateStyle;

  const CustomDatePickerStyle({
    required this.dayStyle,
    required this.dayBackground,
    required this.dateBackground,
    required this.normalStyle,
    required this.nowStyle,
    required this.selectDateStyle,
    required this.selectBackground,
    required this.disableDateStyle,
  });
}

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({
    Key? key,
    this.startDayOfWeek = 1,
    this.initDate,
    this.onMonthChange,
    this.onDateSelected,
    this.startLimit,
    this.endLimit,
    this.datePickerStyle = const CustomDatePickerStyle(
      dayBackground: Color(0xFFf2f3f4),
      dayStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      dateBackground: Colors.transparent,
      normalStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      nowStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF3aaa35)),
      selectDateStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      selectBackground: Color(0xFF3aaa35),
      disableDateStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
    ),
  }) : super(key: key) {
    assert(
      startDayOfWeek == 1 || startDayOfWeek == 7,
      'startDayOfWeek must be Monday(1) or Sunday(7)',
    );
  }

  final CustomDatePickerStyle datePickerStyle;

  ///Mặc định không truyền sẽ là thứ 2
  final int startDayOfWeek;

  //pass init time
  final DateTime? initDate;

  //listen when change month
  final ValueChanged<DateTime>? onMonthChange;

  //listen when select date
  final ValueChanged<DateTime>? onDateSelected;

  final DateTime? startLimit;

  final DateTime? endLimit;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();

  Future<DateTime?> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<DateTime?>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: this,
      ),
    );
  }
}

enum PickerType { date, month, year }

extension _ControllerCustomDatePickerState on _CustomDatePickerState {
  void nextMonth() {
    _controller.animateToPage(
      (_controller.page?.round() ?? _CustomDatePickerState._intPage) + 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void preMonth() {
    _controller.animateToPage(
      (_controller.page?.round() ?? _CustomDatePickerState._intPage) - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  Widget _nextButton(Widget icon, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        iconColor: Colors.black,
        backgroundColor: Color(0xFFe7e8ea),
        padding: EdgeInsets.zero,
        maximumSize: Size(40, 40),
        minimumSize: Size(40, 40),
        alignment: Alignment.center,
      ),
      child: icon,
    );
  }

  Widget _buildController() {
    switch (pickerType) {
      case PickerType.date:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _nextButton(Icon(Icons.arrow_back), preMonth),
                Spacer(),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _monthNotifier,
                  builder: (context, value, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final month =
                                await MonthPicker(initMonth: _monthNotifier.value.month).showCenterDialog(context);
                            if (month != null) {
                              if (month != _monthNotifier.value.month) {
                                _controller.animateToPage(
                                  (_controller.page?.round() ?? _CustomDatePickerState._intPage) +
                                      (month - _monthNotifier.value.month),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                              }
                            }
                          },
                          child: Text(
                            'Tháng ${value.month}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final year =
                                await CustomYearPicker(initYear: _monthNotifier.value.year).showCenterDialog(context);
                            if (year != null) {
                              if (_monthNotifier.value.year != year) {
                                _controller.animateToPage(
                                  (_controller.page?.round() ?? _CustomDatePickerState._intPage) +
                                      ((year - _monthNotifier.value.year) * 12).round(),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                              }
                            }
                          },
                          child: Text(
                            '${value.year}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Spacer(),
                _nextButton(Icon(Icons.arrow_forward), nextMonth),
              ],
            ),
          ],
        );

      case PickerType.month:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      pickerType = PickerType.date;
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_back)),
                Spacer(),
                Text('Chọn tháng'),
                Spacer(),
              ],
            ),
          ],
        );
      case PickerType.year:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                Spacer(),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _monthNotifier,
                  builder: (context, value, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            pickerType = PickerType.month;
                            setState(() {});
                          },
                          child: Text(
                            'Tháng ${value.month}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '${value.year}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Spacer(),
                _nextButton(Icon(Icons.arrow_forward), nextMonth),
              ],
            ),
          ],
        );
    }
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final ValueNotifier<DateTime> _monthNotifier = ValueNotifier(DateTime.now());

  PickerType pickerType = PickerType.date;

  DateTime? _selectDate;

  late final DateTime _initDate;

  static const int _intPage = 100 * 12; //100 năm

  final PageController _controller = PageController(initialPage: _intPage);

  int _getMonthBetween(DateTime dateTime) {
    int year = dateTime.year - _initDate.year;
    int month = dateTime.month - _initDate.month;

    return year * 12 + month;
  }

  //set ngày từ input field truyền vào
  void setStartDate(DateTime dateTime, {bool isFromInput = false}) {
    //check limit start
    if (widget.startLimit != null) {
      if (dateTime.isBefore(widget.startLimit!)) {
        dateTime = widget.startLimit!;
      }
    }

    //check limit end
    if (widget.endLimit != null) {
      if (dateTime.isAfter(widget.endLimit!)) {
        dateTime = widget.endLimit!;
      }
    }

    _selectDate = dateTime;

    _controller.animateToPage(
      (_getMonthBetween(dateTime) + _intPage),
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    setState(() {});
  }

  void setEndDate(DateTime dateTime, {bool isFromInput = false}) {
    setStartDate(dateTime, isFromInput: isFromInput);
  }

  @override
  void initState() {
    super.initState();
    _selectDate = widget.initDate;
    _initDate = _selectDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    _monthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double ratio = 49 / 32;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / 7;
        final itemHeight = itemWidth / ratio;
        final gridHeight = itemHeight * 7 + 48;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildController(),
            if (pickerType == PickerType.date)
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: ratio,
                ),
                itemBuilder: (_, index) => _buildWeekDay(index),
                itemCount: 7,
              ),
            const SizedBox(height: 8),
            if (pickerType == PickerType.date)
              SizedBox(
                height: gridHeight - itemHeight - 8,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    final month = DateTime(_initDate.year, _initDate.month + (index + 1 - _intPage), 0);
                    _monthNotifier.value = month;
                    widget.onMonthChange?.call(month);
                  },
                  itemBuilder: (context, index) {
                    return _AMonthView(
                      startDayOfWeek: widget.startDayOfWeek,
                      datePickerStyle: widget.datePickerStyle,
                      currentMonth: DateTime(_initDate.year, _initDate.month + (index + 1 - _intPage), 0),
                      selectDate: _selectDate,
                      endLimit: widget.endLimit,
                      startLimit: widget.startLimit,
                      onDateSelected: (date) {
                        _selectDate = date;
                        widget.onDateSelected?.call(date);
                      },
                    );
                  },
                ),
              )
            else if (pickerType == PickerType.month)
              SizedBox(height: gridHeight - itemHeight - 8, child: MonthPicker()),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: () {},
                child: Center(
                  child: Text(
                    'Áp dụng',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget _buildWeekDay(int index) {
    int day = index + widget.startDayOfWeek % 7;

    String getTitle() {
      if (day == 7 || day == 0) {
        return 'CN';
      }
      return 'T${day + 1}';
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        getTitle(),
        textAlign: TextAlign.center,
        style: widget.datePickerStyle.dayStyle,
      ),
    );
  }
}

enum _SelectedType {
  normal, //date can be select
  selected, //current select
  disable, //date can't be select
  now, //now
}

extension _OutOfLimit on DateTime {
  bool isOutOfLimit(DateTime? startLimit, DateTime? endLimit) {
    if (startLimit != null && endLimit != null) {
      assert(endLimit.isAfter(startLimit), 'startLimit must before endLimit');
    }

    if (startLimit != null) {
      if (isBefore(startLimit)) {
        return true;
      }
    }

    if (endLimit != null) {
      if (isAfter(endLimit)) {
        return true;
      }
    }

    return false;
  }
}

/// Use to specify the order of the date for the calendar
extension _IndexOfFirstDate on DateTime {
  int getDayOrderIndex(int startDayOfWeek) {
    final weekday = this.weekday ?? 1;
    if (startDayOfWeek == 1) {
      return weekday - 1;
    }

    return weekday;
  }
}

class DateBuilder {
  final CustomDatePickerStyle datePickerStyle;
  final DateTime? startLimit;
  final DateTime? endLimit;

  DateBuilder({
    required this.datePickerStyle,
    this.startLimit,
    this.endLimit,
  });

  Widget buildDate(DateTime dateTime, DateTime? selectDate, VoidCallback onTap) {
    Widget buildItem(TextStyle style) {
      return _DateLayout(
        onTap: onTap,
        child: Text(
          dateTime.day.toString(),
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    }

    switch (_getType(dateTime, selectDate)) {
      case _SelectedType.normal:
        return buildItem(datePickerStyle.normalStyle);
      case _SelectedType.selected:
        return buildItem(datePickerStyle.selectDateStyle);
      case _SelectedType.disable:
        return buildItem(datePickerStyle.disableDateStyle);
      case _SelectedType.now:
        return _DateLayout(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Text(
                  dateTime.day.toString(),
                  textAlign: TextAlign.center,
                  style: datePickerStyle.nowStyle,
                ),
              ),
              SizedBox(width: dateTime.day.toString().getWidthText(), height: 2)
            ],
          ),
        );
    }
  }

  _SelectedType _getType(DateTime date, DateTime? selectDate) {
    if (date.isOutOfLimit(startLimit, endLimit)) {
      return _SelectedType.disable;
    } else if (selectDate != null && date.isSameDate(selectDate)) {
      return _SelectedType.selected;
    } else if (date.isSameDate(DateTime.now())) {
      return _SelectedType.now;
    }
    return _SelectedType.normal;
  }
}

class _AMonthView extends StatefulWidget {
  const _AMonthView({
    Key? key,
    this.selectDate,
    this.onDateSelected,
    this.startLimit,
    this.endLimit,
    required this.currentMonth,
    required this.startDayOfWeek,
    required this.datePickerStyle,
  }) : super(key: key);

  final DateTime? selectDate;
  final DateTime currentMonth;
  final int startDayOfWeek;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? startLimit;
  final DateTime? endLimit;
  final CustomDatePickerStyle datePickerStyle;

  @override
  State<_AMonthView> createState() => _AMonthViewState();
}

class _AMonthViewState extends State<_AMonthView> {
  DateTime? _selectDate;

  late DateTime _firstDayOfMonth;

  late DateTime _startLimit;

  late DateTime _endLimit;

  late int indexOfFirstDayOfMonth;

  late DateBuilder _dateBuilder;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant _AMonthView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectDate != _selectDate || oldWidget.currentMonth != widget.currentMonth) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double ratio = 49 / 32;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: ratio,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        DateTime date = _firstDayOfMonth.add(Duration(days: index - indexOfFirstDayOfMonth));
        return _dateBuilder.buildDate(date, _selectDate, () => onDateSelect(date));
      },
      itemCount: 7 * 6,
    );
  }

  void onDateSelect(DateTime date) {
    widget.onDateSelected?.call(date);
    _selectDate = date;
    setState(() {});
  }
}

extension _InitAMonthViewState on _AMonthViewState {
  _init() {
    _selectDate = widget.selectDate;

    _firstDayOfMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month);

    indexOfFirstDayOfMonth = _firstDayOfMonth.getDayOrderIndex(widget.startDayOfWeek);

    _setUpLimitDate(_firstDayOfMonth, DateTime(widget.currentMonth.year, widget.currentMonth.month + 1, 0));

    _dateBuilder = DateBuilder(
      datePickerStyle: widget.datePickerStyle,
      startLimit: _startLimit,
      endLimit: _endLimit,
    );
  }

  void _setUpLimitDate(DateTime startDate, DateTime endDate) {
    _startLimit = startDate;
    _endLimit = endDate;

    if (widget.startLimit != null && widget.startLimit!.isAfter(startDate)) {
      _startLimit = widget.startLimit!;
    }

    if (widget.endLimit != null && widget.endLimit!.isBefore(endDate)) {
      _endLimit = widget.endLimit!;
    }
  }
}

class _DateLayout extends StatelessWidget {
  const _DateLayout({
    Key? key,
    required this.child,
    this.color,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Align(
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class DateTimeRangePickerWidget extends StatefulWidget {
  DateTimeRangePickerWidget({
    Key? key,
    this.onDateChange,
    this.startLimitDate,
    this.endLimitDate,
    this.startSelectDate,
    this.endSelectDate,
  }) : super(key: key);

  final Function(DateTime? start, DateTime? end, bool? isClickDay)? onDateChange;
  final DateTime? startLimitDate;
  final DateTime? endLimitDate;
  final DateTime? startSelectDate;
  final DateTime? endSelectDate;

  @override
  State<DateTimeRangePickerWidget> createState() => _DateTimeRangePickerWidgetState();
}

class _DateTimeRangePickerWidgetState extends State<DateTimeRangePickerWidget> {
  final ValueNotifier<DateTime> _monthNotifier = ValueNotifier(DateTime.now());

  final ValueNotifier<bool> _startDateValidateNotifier = ValueNotifier(true);

  final ValueNotifier<bool> _endDateValidateNotifier = ValueNotifier(true);

  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();

  final GlobalKey<_CustomDatePickerState> _dateTimeKey = GlobalKey();

  final FocusNode _startFocusNode = FocusNode();

  final FocusNode _endFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.startSelectDate != null) {
        _dateTimeKey.currentState?.setStartDate(widget.startSelectDate!);
      }
      if (widget.endSelectDate != null) {
        _dateTimeKey.currentState?.setEndDate(widget.endSelectDate!);
      }

      _startFocusNode.requestFocus();

      _startFocusNode.addListener(() {
        if (_startFocusNode.hasFocus) {
          // _dateTimeKey.currentState?.focusStartDate();
        }
      });

      _endFocusNode.addListener(() {
        if (_endFocusNode.hasFocus) {
          // _dateTimeKey.currentState?.focusEndDate();
        }
      });
    });
  }

  @override
  void dispose() {
    _monthNotifier.dispose();
    _startDateValidateNotifier.dispose();
    _endDateValidateNotifier.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startFocusNode.dispose();
    _endFocusNode.dispose();
    super.dispose();
  }

  void _validateStartDate(String value) {
    if (value.length > DateTimeFormat.ddMMyyyy.length) {
      _startDateValidateNotifier.value = false;
      return;
    }
    try {
      intl.DateFormat(DateTimeFormat.ddMMyyyy).parse(value);
      _startDateValidateNotifier.value = true;
    } catch (e) {
      _startDateValidateNotifier.value = false;
    }
  }

  void _validateEndDate(String value) {
    if (value.length > DateTimeFormat.ddMMyyyy.length) {
      _endDateValidateNotifier.value = false;
      return;
    }
    try {
      intl.DateFormat(DateTimeFormat.ddMMyyyy).parse(value);
      _endDateValidateNotifier.value = true;
    } catch (e) {
      _endDateValidateNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ColoredBox(
        //   color: color_gray_25,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: spacing_lg, vertical: spacing_md),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: ValueListenableBuilder<bool>(
        //             valueListenable: _startDateValidateNotifier,
        //             builder: (context, isValidate, _) {
        //               return SddsInputField2(
        //                 focusNode: _startFocusNode,
        //                 controller: _startDateController,
        //                 hintText: 'Ngày bắt đầu',
        //                 isErrorText: !isValidate,
        //                 readOnly: true,
        //                 suffix: IconButton(
        //                   padding: EdgeInsets.zero,
        //                   onPressed: () {},
        //                   icon: SddsImage.asset(
        //                     IconPaths.icon24_calendar_dates,
        //                     height: ViewSize.SIZE_24,
        //                   ),
        //                 ),
        //                 onSubmitted: (value) {
        //                   if (isValidate) {
        //                     try {
        //                       final DateTime date = intl.DateFormat(DateTimeFormat.ddMMyyyy).parse(value);
        //                       _dateTimeKey.currentState?.setStartDate(date, isFromInput: true);
        //                     } catch (e) {}
        //                   }
        //                 },
        //                 onChanged: _validateStartDate,
        //               );
        //             },
        //           ),
        //         ),
        //         // const SizedBox(width: spacing_sm),
        //         // Expanded(
        //         //   child: ValueListenableBuilder<bool>(
        //         //     valueListenable: _endDateValidateNotifier,
        //         //     builder: (context, isValidate, _) {
        //         //       return SddsInputField2(
        //         //         focusNode: _endFocusNode,
        //         //         controller: _endDateController,
        //         //         hintText: 'Ngày kết thúc',
        //         //         isErrorText: !isValidate,
        //         //         readOnly: true,
        //         //         suffix: IconButton(
        //         //             padding: EdgeInsets.zero, onPressed: () {}, icon: Icon(Icons.calendar_month_outlined)),
        //         //         onSubmitted: (value) {
        //         //           if (isValidate) {
        //         //             try {
        //         //               final DateTime date = intl.DateFormat(DateTimeFormat.ddMMyyyy).parse(value);
        //         //               _dateTimeKey.currentState?.setEndDate(date, isFromInput: true);
        //         //             } catch (e) {}
        //         //           }
        //         //         },
        //         //         onChanged: _validateEndDate,
        //         //       );
        //         //     },
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
        Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () {
                          _dateTimeKey.currentState?.preMonth();
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder<DateTime>(
                        valueListenable: _monthNotifier,
                        builder: (context, value, _) {
                          return Text(
                            'Tháng ${value.month}, ${value.year}',
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () {
                          _dateTimeKey.currentState?.nextMonth();
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // CustomDatePicker(
                //   key: _dateTimeKey,
                //   startDayOfWeek: 1,
                //   isPeriodTime: true,
                //   // currentDate: DateTime.now(),
                //   startLimit: widget.startLimitDate,
                //   endLimit: widget.endLimitDate,
                //   onMonthChange: (value) {
                //     _monthNotifier.value = value;
                //   },
                //   onDateSelected: (selectedData) {
                //     _startFocusNode.unfocus();
                //     _endFocusNode.unfocus();
                //   },
                //   onSelectedPeriodDate: (start, end) {
                //     if (start != null) {
                //       _startDateController.text = intl.DateFormat(DateTimeFormat.ddMMyyyy).format(start);
                //     } else {
                //       _startDateController.text = '';
                //     }
                //     if (end != null) {
                //       _endDateController.text = intl.DateFormat(DateTimeFormat.ddMMyyyy).format(end);
                //       _endFocusNode.requestFocus();
                //     } else {
                //       _endDateController.text = '';
                //     }
                //
                //     if (start != null && end == null) {
                //       _startDateController.text = intl.DateFormat(DateTimeFormat.ddMMyyyy).format(start);
                //       _endDateController.text = intl.DateFormat(DateTimeFormat.ddMMyyyy).format(start);
                //       _endFocusNode.requestFocus();
                //     }
                //
                //     widget.onDateChange?.call(start, end, _dateTimeKey.currentState?.isDatesFromInput);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PeriodDate {
  PeriodDate({
    DateTime? start,
    DateTime? end,
    this.maxDuration = 30,
  }) {
    if (start == null && end == null) {
      //bypass
    } else if (start == null || end == null) {
      assert(false, 'If pass data please, start and end both is not null');
    } else {
      assert(start.isBefore(end), 'start must before end');
      assert(start.add(Duration(days: maxDuration)).isAfter(end), 'maxDuration is not valid');
      _time.add(start);
      _time.add(end);
    }
  }

  List<DateTime> _time = [];

  int maxDuration;

  ///người dùng focus vào field input nào thì điền vào ô đó
  bool _isFocusEndDate = false;

  void switchFocus(bool isEnd) {
    _isFocusEndDate = isEnd;
  }

  void addDate(DateTime dateTime) {
    if (_time.isEmpty) {
      _time.add(dateTime);
    } else if (_time.length < 2) {
      if (_time.first.isSameDate(dateTime)) {
        return;
      }
      if ((dateTime.difference(_time.first).inDays.abs() + 1) > (maxDuration)) {
        _time.clear();
        _time.add(dateTime);
        return;
      }

      if (dateTime.isBefore(_time.first)) {
        _time.clear();
        _time.add(dateTime);
        return;
      } else {
        _time.add(dateTime);
      }
    } else if (_time.length == 2) {
      if (_isFocusEndDate) {
        if (!dateTime.isBefore(_time.first)) {
          _time[1] = dateTime;
          return;
        }
      }
      _time.clear();
      _time.add(dateTime);
    }
  }

  bool isBetween(DateTime dateTime) {
    if (_time.length == 2) {
      return _time.first.isBefore(dateTime) && _time.last.isAfter(dateTime);
    }

    return false;
  }

  DateTime? getStart() {
    if (_time.length > 0) {
      return _time[0];
    }
    return null;
  }

  DateTime? getEnd() {
    if (_time.length == 2) {
      return _time[1];
    }
    return null;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension _GetWidthOfText on String {
  double getWidthText() {
    return (TextPainter(text: TextSpan(text: this), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity))
        .width;
  }
}
