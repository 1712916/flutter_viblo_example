import 'package:flutter/material.dart';
import 'package:flutter_example/custom_date_picker/month_picker.dart';
import 'package:flutter_example/custom_date_picker/year_picker.dart';

import 'date_picker.dart';

class DatePage extends StatefulWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CustomDatePicker(
                  // currentDate: DateTime.now(),
                  )
              .showBottomSheet(context);
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDatePicker(
              // currentDate: DateTime.now(),
              ),
        ),
      ),
    );
  }
}

class MonthPage extends StatefulWidget {
  const MonthPage({Key? key}) : super(key: key);

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MonthPicker(
            initMonth: 2,
            startMonth: 1,
            endMonth: 5,
          ).showCenterDialog(context);
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MonthPicker(
            initMonth: 2,
            startMonth: 1,
            endMonth: 5,
          ),
        ),
      ),
    );
  }
}

class YearPage extends StatefulWidget {
  const YearPage({Key? key}) : super(key: key);

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  int _year = 2023;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // void _showDialog(Widget child) {
          //   showCupertinoModalPopup<void>(
          //       context: context,
          //       builder: (BuildContext context) => Container(
          //             height: 400,
          //             padding: const EdgeInsets.only(top: 6.0),
          //             // The Bottom margin is provided to align the popup above the system
          //             // navigation bar.
          //             margin: EdgeInsets.only(
          //               bottom: MediaQuery.of(context).viewInsets.bottom,
          //             ),
          //             // Provide a background color for the popup.
          //             color: CupertinoColors.systemBackground.resolveFrom(context),
          //             // Use a SafeArea widget to avoid system overlaps.
          //             child: SafeArea(
          //               top: false,
          //               child: child,
          //             ),
          //           ));
          // }
          //
          // _showDialog(
          //   CupertinoDatePicker(
          //     initialDateTime: DateTime.now(),
          //     mode: CupertinoDatePickerMode.date,
          //     use24hFormat: true,
          //     // This is called when the user changes the date.
          //     onDateTimeChanged: (DateTime newDate) {},
          //   ),
          // );
          final year = await CustomYearPicker(
            initYear: _year,
            startYear: 2020,
            endYear: 2025,
          ).showCenterDialog(context);
          if (year != null) {
            _year = year;
          }
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomYearPicker(
            initYear: 2023,
            startYear: 2020,
            endYear: 2025,
          ),
        ),
      ),
    );
  }
}
