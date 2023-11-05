import 'package:animation_1/screen/music_player/utils.dart';
import 'package:flutter/material.dart';

class MusicDetail extends StatefulWidget {
  final int index;

  const MusicDetail({super.key, required this.index});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail>
    with TickerProviderStateMixin {
  late final mediaSize = MediaQuery.of(context).size;

  late AnimationController _volumeController = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: 300,
    ),
    lowerBound: 0,
    upperBound: mediaSize.width - 80,
  );

  _onPanUpdate(DragUpdateDetails details) {
    _volumeController.value += details.delta.dx;
  }

  _onPanDown(DragDownDetails details) {
    final local = details.localPosition;
    _volumeController.value = local.dx;
    // _volumeController.value += details.delta.dx;
  }

  @override
  Widget build(BuildContext context) {
    final path = imgPath(widget.index);
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Music detail",
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 40,
            right: 40,
          ),
          child: Column(
            children: [
              Hero(
                tag: path,
                child: Container(
                  width: _size.width * 0.8,
                  height: 320,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(path),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedBuilder(
                animation: _volumeController,
                builder: (context, child) {
                  return GestureDetector(
                    onPanDown: _onPanDown,
                    onPanUpdate: _onPanUpdate,
                    child: CustomPaint(
                      painter: Volume(progress: _volumeController.value),
                      size: Size(
                        _size.width,
                        10,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("00:00"),
                  Text("00:00"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Volume extends CustomPainter {
  final double progress;

  Volume({super.repaint, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final containerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade400;

    canvas.drawRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        Radius.circular(10),
      ),
      containerPaint,
    );

    final indicatorPaint = Paint()..color = Colors.grey;

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, progress, size.height, Radius.circular(10)),
      indicatorPaint,
    );

    final circlePaint = Paint()..color = Colors.grey;
    final Pointer =
        canvas.drawCircle(Offset(progress, size.height / 2), 14, circlePaint);
  }

  @override
  bool shouldRepaint(covariant Volume oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
