import 'dart:ui';

import 'package:animation_1/screen/music_player/music_player_detail.dart';
import 'package:animation_1/screen/music_player/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with TickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: 200,
    ),
  );

  late PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  int pageIndex = 1;

  ValueNotifier<double> _screen = ValueNotifier(1);

  @override
  void initState() {
    _pageController.addListener(
      () {
        _screen.value = _pageController.page!;
      },
    );
    super.initState();
  }

  int getIndex(int index) {
    if (index > 5) return 1;
    if (index < 1) return 5;
    return index;
  }

  void _pageChanged(int index) {
    setState(() {
      pageIndex = getIndex(index + 1);
    });
  }

  void _onTapHero(int index) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(
        seconds: 1,
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        final CurvedAnimation curve = CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate,
        );
        Animation<double> _opacity = Tween(begin: 0.0, end: 1.0).animate(curve);

        return FadeTransition(
          opacity: _opacity,
          child: MusicDetail(
            index: index,
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Container(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.5,
                    ),
                  ),
                ),
                key: ValueKey(pageIndex),
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                        0.5,
                      ),
                      BlendMode.overlay,
                    ),
                    fit: BoxFit.cover,
                    image: AssetImage(
                      imgPath(pageIndex),
                    ),
                  ),
                ),
              ),
            ),
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _pageChanged,
              itemCount: 5,
              itemBuilder: (context, index) {
                final whiteText = TextStyle(
                  color: Colors.white,
                );
                return Padding(
                  key: ValueKey(index),
                  padding: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _screen,
                        builder: (context, screen, child) {
                          final factor = screen - index;
                          final scale = 1 - factor.abs() * 0.1;
                          return Transform.scale(
                            scale: scale,
                            child: Hero(
                              tag: imgPath(index + 1),
                              child: GestureDetector(
                                onTap: () => _onTapHero(index + 1),
                                child: Container(
                                  height: size.width * 0.9,
                                  width: size.width * 0.7,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(3, 3),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.normal,
                                      )
                                    ],
                                    color: Colors.red,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        imgPath(index + 1),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        style: whiteText,
                        "title",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        style: whiteText,
                        "desc",
                      ),
                    ],
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
