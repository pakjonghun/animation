import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String imgPath(int index) {
    return "assets/images/$index.jpg";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    int pageIndex = 0;

    void _pageChanged(int index) {
      setState(() {
        pageIndex = index;
      });
    }

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
                key: ValueKey(pageIndex),
                width: 1000,
                height: 500,
                color: Colors.black.withOpacity(0.5),
                child: Text(pageIndex.toString()),
              ),
            ),
            PageView.builder(
              onPageChanged: _pageChanged,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  key: ValueKey(index),
                  padding: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.width * 0.9,
                        width: size.width * 0.7,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "title",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
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
