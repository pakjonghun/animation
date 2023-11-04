import 'dart:math';

import 'package:flutter/material.dart';

class CardSwitch extends StatefulWidget {
  const CardSwitch({super.key});

  @override
  State<CardSwitch> createState() => _CardSwitchState();
}

class _CardSwitchState extends State<CardSwitch> with TickerProviderStateMixin {
  int index = 1;
  late final width = MediaQuery.of(context).size.width;

  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: 1000,
    ),
    upperBound: (width + 100),
    lowerBound: -(width + 100),
    value: 0,
  );

  Tween<double> _angle = Tween<double>(
    begin: -15 * pi / 180,
    end: 15 * pi / 180,
  );

  Tween<double> _scale = Tween<double>(
    begin: -1,
    end: 1,
  );

  ColorTween _leftButtonBgColor = ColorTween(
    begin: Colors.pinkAccent,
    end: Colors.pink[200],
  );

  ColorTween _leftButtonIconColor = ColorTween(
    begin: Colors.pink[50],
    end: Colors.white,
  );

  Tween<double> _buttonScale = Tween(
    begin: 1,
    end: 1.2,
  );

  double _calculatedFactor({
    required double toDis,
    bool? isHalfFigure = false,
  }) {
    final fromDis = width * 2;
    double normalizedFactor = isHalfFigure == false
        ? (_controller.value + width) / fromDis
        : _controller.value.abs() / fromDis;

    return normalizedFactor;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value += details.delta.dx;
  }

  bool get isNext => _controller.value > 0;

  int getIndex(int index) {
    if (index < 0) return 5;
    if (index > 5) return 1;
    return index;
  }

  void _whenCompleted() {
    _controller.value = 0;
    setState(() {
      index = getIndex(index + 1);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final isInBound = _controller.value.abs() > width - 200;

    if (isInBound) {
      _controller
          .animateTo(
            _controller.value + (isNext ? 200 : -200),
          )
          .whenComplete(_whenCompleted);
    } else {
      _controller.animateTo(0);
    }
  }

  void _onLeftIconTap() {
    _controller.animateTo(-width).whenComplete(_whenCompleted);
  }

  void _onRightIconTap() {
    _controller.animateTo(width).whenComplete(_whenCompleted);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "card_switch",
        ),
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final curAnimationValue = _controller.value;
            return Padding(
              padding: EdgeInsets.only(
                top: 100,
              ),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Transform.scale(
                            scale: _scale
                                .transform(
                                  _calculatedFactor(toDis: 2),
                                )
                                .abs(),
                            child: Card(
                              width: width,
                              index: getIndex(index + 1),
                            ),
                          ),
                        ),
                        Positioned(
                          child: GestureDetector(
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            child: Transform.translate(
                              offset: Offset(_controller.value, 0),
                              child: Transform.rotate(
                                angle: _angle.transform(
                                  _calculatedFactor(
                                    toDis: _angle.end! - _angle.begin!,
                                  ),
                                ),
                                child: Card(
                                  width: width,
                                  index: getIndex(index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: curAnimationValue < 0
                            ? _buttonScale.transform(
                                _calculatedFactor(
                                  toDis: 2.4,
                                  isHalfFigure: true,
                                ),
                              )
                            : 1,
                        child: GestureDetector(
                          onTap: _onLeftIconTap,
                          child: Container(
                            padding: EdgeInsets.all(
                              3,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _leftButtonBgColor.lerp(
                                curAnimationValue < 0
                                    ? _calculatedFactor(
                                        toDis: width * 2,
                                      )
                                    : 1,
                              ),
                            ),
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 40,
                              color: _leftButtonIconColor.lerp(
                                curAnimationValue < 0
                                    ? _calculatedFactor(
                                        toDis: width * 2,
                                      )
                                    : 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Transform.scale(
                        scale: curAnimationValue > 0
                            ? _buttonScale.transform(
                                _calculatedFactor(
                                  toDis: 2.4,
                                  isHalfFigure: true,
                                ),
                              )
                            : 1,
                        child: GestureDetector(
                          onTap: _onRightIconTap,
                          child: Container(
                            padding: EdgeInsets.all(
                              3,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _leftButtonBgColor.lerp(
                                curAnimationValue > 0
                                    ? _calculatedFactor(
                                        toDis: width * 2,
                                      )
                                    : 1,
                              ),
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 40,
                              color: _leftButtonIconColor.lerp(
                                curAnimationValue > 0
                                    ? _calculatedFactor(
                                        toDis: width * 2,
                                      )
                                    : 1,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    super.key,
    required this.width,
    required this.index,
  });

  final double width;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(
        10,
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      child: SizedBox(
        width: width * 0.8,
        height: width,
        child: Image.asset(
          "assets/images/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
