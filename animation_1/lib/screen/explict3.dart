import 'package:flutter/material.dart';

class Explicit3 extends StatefulWidget {
  const Explicit3({super.key});

  @override
  State<Explicit3> createState() => _Explicit3State();
}

class _Explicit3State extends State<Explicit3> with TickerProviderStateMixin {
  late AnimationController _animationController;

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

    // ..addListener(
    //     () {
    //       _value.value = _animationController.value;
    //     },
    //   );
  }

  void _onTapShape() {}

  @override
  void dispose() {
    _animationController.dispose();

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

  ValueNotifier<double> _value = ValueNotifier(0.0);

  void _onSlide(double value) {
    // _animationController.animateTo(_value.value);
    // _value.value = 0;
    _value.value = value;
    _animationController.value = value;
    ;
    // _animationController.animateTo(_value.value);
  }

  @override
  Widget build(BuildContext context) {
    print(1);
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
              position: _sliceTween.animate(_animationController),
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
            ValueListenableBuilder(
                valueListenable: _value,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    onChanged: _onSlide,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
