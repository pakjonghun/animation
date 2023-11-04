import 'dart:math';

import 'package:flutter/material.dart';

class CardSwitch extends StatefulWidget {
  const CardSwitch({super.key});

  @override
  State<CardSwitch> createState() => _CardSwitchState();
}

class _CardSwitchState extends State<CardSwitch> with TickerProviderStateMixin {
  int direction = 0;
  int index = 1;

  String getPath(int index) {
    return 'assets/images/$index.jpg';
  }

  int getIndex(int index) {
    if (index < 1) return 5;
    if (index > 5) return 1;
    return index;
  }

  late final size = MediaQuery.of(context).size;
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: 1000,
    ),
    upperBound: size.width + 100,
    lowerBound: -(size.width + 100),
    value: 0,
  );

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value += details.delta.dx;
  }

  void _whenEnd() {
    setState(() {
      direction = 0;
      index = getIndex(index + 1);
    });

    _controller.value = 0;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_controller.value.abs() > size.width - 100) {
      double offset = _controller.value < 0 ? -100 : 100;
      _controller.animateTo(_controller.value + offset).whenComplete(_whenEnd);
    } else {
      _controller.animateTo(0);
    }
  }

  void _back() {
    _controller.animateTo(-size.width).whenComplete(_whenEnd);
  }

  void _forward() {
    _controller.animateTo(size.width).whenComplete(_whenEnd);
  }

  Tween<double> _scale = Tween<double>(begin: 0.5, end: 1);
  Tween<double> _rotate = Tween<double>(begin: 0, end: 15);
  Tween<double> _buttonScale = Tween<double>(begin: 1, end: 1.5);
  ColorTween _bc = ColorTween(begin: Colors.pink[400], end: Colors.pink[200]);
  ColorTween _fc = ColorTween(begin: Colors.white, end: Colors.black);

  double getDiffMappedDouble({
    required double fromH,
    required double fromL,
    required double toH,
    required double toL,
    required double fromValue,
    required bool isReverse,
  }) {
    final fromD = fromH - fromL;
    final toD = toH - toL;
    final fromLowToValue = (fromValue - fromL) / (fromD);
    final toValue =
        isReverse ? toH - toD * fromLowToValue : toL + toD * fromLowToValue;
    return toValue;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "card switch",
        ),
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final bool isLeftBound = _controller.value < 0;
            final bool isRightBound = _controller.value > 0;

            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 100,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          child: Transform.scale(
                            scale: _scale.transform(
                              ((0.5 / _controller.upperBound * 2) *
                                  _controller.value.abs()),
                            ),
                            child: SizedBox(
                              width: size.width * 0.8,
                              height: size.width,
                              child: Material(
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  fit: BoxFit.cover,
                                  getPath(
                                    getIndex(
                                      index + 1,
                                    ),
                                  ),
                                ),
                                elevation: 10,
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: SizedBox(
                            width: width * 0.8,
                            height: width,
                            child: GestureDetector(
                              onPanEnd: _onPanEnd,
                              onPanUpdate: _onPanUpdate,
                              child: Transform.translate(
                                offset: Offset(_controller.value, 0),
                                child: Transform.rotate(
                                  angle: _rotate.transform(((15 /
                                              ((_controller.upperBound - 100) *
                                                  2)) *
                                          _controller.value)) *
                                      (pi / 180),
                                  child: Material(
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      fit: BoxFit.cover,
                                      getPath(
                                        getIndex(
                                          index,
                                        ),
                                      ),
                                    ),
                                    elevation: 10,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: isLeftBound
                              ? _buttonScale.transform(
                                  (0.5 / (size.width * 2)) *
                                      _controller.value.abs())
                              : 1,
                          child: GestureDetector(
                            onTap: _back,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _bc.lerp(isLeftBound
                                      ? _controller.value.abs() / size.width * 2
                                      : 1)),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: _fc.lerp(isLeftBound
                                    ? _controller.value.abs() / size.width * 2
                                    : 1),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Transform.scale(
                          scale: isRightBound
                              ? _buttonScale.transform(
                                  (0.5 / (size.width * 2)) *
                                      _controller.value.abs())
                              : 1,
                          child: GestureDetector(
                            onTap: _forward,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _bc.lerp(isRightBound
                                    ? _controller.value.abs() / size.width * 2
                                    : 1),
                              ),
                              child: Icon(
                                Icons.free_breakfast_outlined,
                                color: _fc.lerp(isRightBound
                                    ? _controller.value.abs() / size.width * 2
                                    : 1),
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
