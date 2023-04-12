import 'package:flutter/material.dart';
import 'package:flutter_example/custom_date_picker/month_picker.dart';

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
          CustomDatePicker(
                  // currentDate: DateTime.now(),
                  )
              .showBottomSheet(context);
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MonthPicker(
            initMonth: 2,
            startMonth: 3,
            endMonth: 5,
          ),
        ),
      ),
    );
  }
}
