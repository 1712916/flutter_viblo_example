import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class OffsetExamplePage extends StatefulWidget {
  const OffsetExamplePage({super.key});

  @override
  State<OffsetExamplePage> createState() => _OffsetExamplePageState();
}

class _OffsetExamplePageState extends State<OffsetExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offset Example Page")),
      body: const ClockWidget(),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({super.key});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500));

    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutCubicEmphasized);
    animation.addListener(() {
      setState(() {});
    });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomPaint(
      size: size,
      painter: PlaygroundPainter(animationValue: animation.value),
    );
  }
}

class PlaygroundPainter extends CustomPainter {
  PlaygroundPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    /// We shift the coordinates to the center of the screen
    canvas.translate(size.width / 2, size.height / 2);

    final circlePosition = Offset.lerp(const Offset(0, -120), const Offset(0, 120), animationValue)!;

    /// draws a circle of radius 40 and give it the position above
    canvas.drawCircle(circlePosition, 40, Paint()..color = Colors.red);
  }

  /// We expect this to re-paint when there's a change in animation value
  @override
  bool shouldRepaint(PlaygroundPainter oldDelegate) => true;
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> with SingleTickerProviderStateMixin {
  DateTime dateTime = DateTime.now();

  void changeTime(double minute) {
    this.dateTime = DateTime.now();
    setState(() {});
  }

  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) => computationCount,
    ).listen((event) {
      changeTime(event.toDouble());
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          key: const ValueKey('ClockwisePainter'),
          willChange: true,
          size: size,
          painter: ClockwisePainter(dateTime.hour.toDouble(), dateTime.minute.toDouble(), dateTime.second.toDouble()),
        ),
        CustomPaint(
          key: const ValueKey('ClockPainter'),
          willChange: false,
          size: size,
          painter: ClockPainter(),
        ),
      ],
    );
  }
}

// Total angle of a circle is 360
const totalDegree = 360;

// Total ticks to display
const totalTicks = 12;

const totalTickMinutes = 60;

const unitAngle = totalDegree / totalTicks;

const unitAngleMinutes = totalDegree / totalTickMinutes;

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// We shift the coordinates to the center of the screen
    canvas.translate(size.width / 2, size.height / 2);

    /// The angle between each tick

    final clockPaint = Paint()
      ..color = Colors.red[900]!.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    /// Draws the clock circle frame
    canvas.drawCircle(
      Offset.zero,
      90,
      clockPaint,
    );

    for (int i = 0; i <= 59; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      final angle = -90.radians + (i * unitAngleMinutes).radians;

      /// Draws the tick for each angle
      canvas.drawLine(
        Offset.fromDirection(angle, 85),
        Offset.fromDirection(angle, 90),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 1,
      );
    }

    for (int i = 0; i <= 11; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      final angle = -90.radians + (i * unitAngle).radians;

      /// Draws the tick for each angle
      canvas.drawLine(
        Offset.fromDirection(angle, 80),
        Offset.fromDirection(angle, 90),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2,
      );
    }

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      6,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.red[900]!,
    );

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    final textSpan = TextSpan(
      text: 'Rolex',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width) / 2;
    final yCenter = (size.height) / 2;
    final offset = Offset((0 - textPainter.width) / 2, 20);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => true;
}

class ClockwisePainter extends CustomPainter {
  final double hour;
  final double minute;
  final double second;

  ClockwisePainter(this.hour, this.minute, this.second);

  @override
  void paint(Canvas canvas, Size size) {
    /// We shift the coordinates to the center of the screen
    canvas.translate(size.width / 2, size.height / 2);

    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(-90.radians + (hour * unitAngleMinutes).radians, 30),
      Paint()
        ..color = Colors.red[400]!
        ..strokeWidth = 4,
    );

    final angle = -90.radians + (minute * unitAngleMinutes).radians;
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(angle, 50),
      Paint()
        ..color = Colors.red[400]!
        ..strokeWidth = 4,
    );

    final angle2 = -90.radians + (second * unitAngleMinutes).radians;
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(angle2, 60),
      Paint()
        ..color = Colors.red[400]!
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(ClockwisePainter oldDelegate) => true;
}

extension on num {
  /// This is an extension we created so we can easily convert a value  /// to a radian value
  double get radians => (this * math.pi) / 180.0;
}
