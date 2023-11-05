import 'package:animation_1/screen/apple_watch.dart';
import 'package:animation_1/screen/card_switch/card_switch.dart';
import 'package:animation_1/screen/explict.dart';
import 'package:animation_1/screen/explict2.dart';
import 'package:animation_1/screen/explict3.dart';
import 'package:animation_1/screen/music_player/music_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen());
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _movePage({required BuildContext context, required Widget screen}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () =>
                    _movePage(context: context, screen: const Explicit()),
                child: const Text(
                  "explicit animation",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () =>
                    _movePage(context: context, screen: const Explicit2()),
                child: const Text(
                  "explicit animation2",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () =>
                    _movePage(context: context, screen: const Explicit3()),
                child: const Text(
                  "explicit animation3",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text(
                  "apple watch",
                ),
                onPressed: () => _movePage(
                  context: context,
                  screen: const AppleWatchScreen(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _movePage(
                  context: context,
                  screen: const CardSwitch(),
                ),
                child: Text(
                  "card switch",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _movePage(
                  context: context,
                  screen: const MusicPlayer(),
                ),
                child: Text(
                  "music player",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
