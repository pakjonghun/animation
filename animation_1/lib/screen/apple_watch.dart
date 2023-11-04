import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(
      seconds: 2,
    ),
  );

  late Animation<double> _first;
  late Animation<double> _second;
  late Animation<double> _third;
  double _start = pi / 2 * -1;

  double getRandomPi() {
    const double start = pi / 2 * -1;
    const double end = pi * 2;

    return start + Random().nextDouble() * (end - start);
  }

  @override
  void initState() {
    _first = Tween<double>(begin: getRandomPi(), end: getRandomPi())
        .animate(_animationController);

    _second = Tween<double>(begin: getRandomPi(), end: getRandomPi())
        .animate(_animationController);

    _third = Tween<double>(begin: getRandomPi(), end: getRandomPi())
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> getTweenAnimation(double start) {
    return Tween<double>(begin: start, end: getRandomPi())
        .animate(_animationController);
  }

  void _resetAnimation() {
    setState(() {
      _start = getRandomPi();
      _first = getTweenAnimation(_start);
      _second = getTweenAnimation(_start);
      _third = getTweenAnimation(_start);
    });

    if (_animationController.isAnimating) return;
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          "Apple watch",
        ),
      ),
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.8,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => CustomPaint(
                      painter: AppleWatch(
                          start: _start,
                          first: _first.value,
                          second: _second.value,
                          third: _third.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: _resetAnimation,
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppleWatch extends CustomPainter {
  final double first;
  final double second;
  final double third;
  final double start;

  AppleWatch({
    super.repaint,
    required this.first,
    required this.second,
    required this.third,
    required this.start,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const dis = 0.25;

    Paint getPaint({required Color color}) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25
        ..color = color;
    }

    final firstCircle = getPaint(
        color: Colors.red.withOpacity(
      0.5,
    ));
    final secondCircle = getPaint(
        color: Colors.blue.withOpacity(
      0.5,
    ));
    final thirdCircle = getPaint(
        color: Colors.lime.withOpacity(
      0.5,
    ));

    double getRadius(int disCount) {
      return size.width / 2 * (1 - dis * disCount);
    }

    canvas.drawCircle(center, getRadius(0), firstCircle);
    canvas.drawCircle(center, getRadius(1), secondCircle);
    canvas.drawCircle(center, getRadius(2), thirdCircle);

    final firstRect = Rect.fromCircle(center: center, radius: getRadius(0));
    final secondRect = Rect.fromCircle(center: center, radius: getRadius(1));
    final thirdRect = Rect.fromCircle(center: center, radius: getRadius(2));

    final firstArc = getPaint(color: Colors.red)..strokeCap = StrokeCap.round;
    final secondArc = getPaint(color: Colors.blue)..strokeCap = StrokeCap.round;
    final thirdArc = getPaint(color: Colors.lime)..strokeCap = StrokeCap.round;

    canvas.drawArc(firstRect, start, first, false, firstArc);
    canvas.drawArc(secondRect, start, second, false, secondArc);
    canvas.drawArc(thirdRect, start, third, false, thirdArc);
  }

  @override
  bool shouldRepaint(covariant AppleWatch oldDelegate) {
    return oldDelegate.first != first &&
        oldDelegate.second != second &&
        oldDelegate.third != third;
  }
}
