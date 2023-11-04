import 'dart:async';

import 'package:flutter/material.dart';

class Explicit2 extends StatefulWidget {
  const Explicit2({super.key});

  @override
  State<Explicit2> createState() => _Explicit2State();
}

class _Explicit2State extends State<Explicit2> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    )..repeat(reverse: true);

    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    )..repeat(reverse: true);
  }

  void _onTapShape() {}

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  late DecorationTween _decorationBoxTween = DecorationTween(
    begin: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
    ),
    end: BoxDecoration(
      color: Colors.purple,
      borderRadius: BorderRadius.circular(1000),
    ),
  );

  // late CurvedAnimation _rotateTween = CurvedAnimation(
  //   parent: _animationController,
  //   curve: Curves.elasticOut,
  // );

  late Tween<double> _rotateTween = Tween<double>(
    begin: 0.0,
    end: 2.0,
  );

  late Tween<Offset> _sliceTween = Tween<Offset>(
    begin: Offset(0, 0.2),
    end: Offset(0, 0),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explicit animation2",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SlideTransition(
              position: _sliceTween.animate(_animationController2),
              child: RotationTransition(
                turns: _rotateTween.animate(_animationController),
                child: DecoratedBoxTransition(
                  decoration: _decorationBoxTween.animate(_animationController),
                  child: Container(
                    // transformAlignment: Alignment.center,
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    // decoration: BoxDecoration(
                    //   color: Colors.red,
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(
                    //       10,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
