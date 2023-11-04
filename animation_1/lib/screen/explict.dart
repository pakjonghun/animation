import 'dart:async';

import 'package:flutter/material.dart';

class Explicit extends StatefulWidget {
  const Explicit({super.key});

  @override
  State<Explicit> createState() => _ExplicitState();
}

class _ExplicitState extends State<Explicit> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController2;
  late Animation<BorderRadius?> _borderRadius;
  late Animation<double> _rotate;
  late Animation<Color?> _color;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    _borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(30),
      end: BorderRadius.circular(500),
    ).animate(_animationController2
        //   CurvedAnimation(
        //   parent: _animationController,
        //   curve: Curves.decelerate,
        // ),
        );

    _rotate = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      _animationController2,
      // CurvedAnimation(
      //   parent: _animationController,
      //   curve: Curves.decelerate,
      // ),
    );

    _color = ColorTween(begin: Colors.red, end: Colors.purple).animate(
        // CurvedAnimation(
        //   parent: _animationController,
        //   curve: Curves.linear,
        // ),
        _animationController);

    _timer = Timer.periodic(
      Duration(milliseconds: 100),
      (timer) {
        print(_animationController.value);
      },
    );
  }

  void _changeRadius() {
    _animationController2.forward();
    _animationController.forward();
    if (_animationController.isCompleted) {
      _animationController2.reverse();
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController2.dispose();
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _play() {
    _animationController2.forward();
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    if (_animationController.isCompleted) {
      _animationController2.reverse();
      _animationController.reverse();
    } else {
      _animationController2.forward();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("1");
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explicit animation",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _play,
                    child: Text("play"),
                  ),
                  TextButton(
                    onPressed: _pause,
                    child: Text("pause"),
                  ),
                  TextButton(
                    onPressed: _rewind,
                    child: Text("rewind"),
                  )
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return GestureDetector(
                  onTap: _changeRadius,
                  child: Container(
                    transformAlignment: Alignment.center,
                    transform: Matrix4.rotationZ(
                      _rotate.value,
                    ),
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: _color.value,
                      borderRadius: _borderRadius.value,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
