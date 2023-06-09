import 'package:flutter/material.dart';
import 'dart:async';

import 'package:auto_lock_windows/auto_lock_windows.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:window_manager/window_manager.dart';

const double windowWidth = 360;
const double windowHeight = 400;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(windowWidth, windowHeight),
    minimumSize: Size(windowWidth, windowHeight),
    maximumSize: Size(windowWidth, windowHeight),
    title: "windows 自动锁屏",
    center: false,
    // backgroundColor: Colors.transparent,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _autoLockWindowsPlugin = AutoLockWindows();
  @override
  void initState() {
    super.initState();

    _sub = _myStream.listen((event) {});
    _editingController.text = settedDuration.toString();
  }

  @override
  void dispose() {
    try {
      _sub.cancel();
    } catch (_) {}
    _editingController.dispose();
    super.dispose();
  }

  late StreamSubscription _sub;

  late int duration = 0;
  late int settedDuration = 30;

  changeDuration(int s) {
    if (s != settedDuration) {
      setState(() {
        settedDuration = s;
        duration = 0;
      });
    }
  }

  late final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) async {
    duration = await _autoLockWindowsPlugin.getDuration();
    setState(() {});

    if (duration > settedDuration) {
      _autoLockWindowsPlugin.lockScreen();
    } else if (duration == (0.75 * (settedDuration)).ceil()) {
      _autoLockWindowsPlugin.playSound();
    }
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            _buildCountDownWidget(),
            const SizedBox(
              height: 30,
            ),
            _buildDuration(),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Dlib智能锁屏(WIP)"))
          ],
        ),
      ),
    );
  }

  final TextEditingController _editingController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _doSomething() async {
    try {
      int newDuration = int.parse(_editingController.text);
      if (newDuration <= 0) {
        throw Exception("间隔不能小于0");
      }
      Timer(const Duration(seconds: 1), () {
        _btnController.success();
      });
      changeDuration(newDuration);
    } catch (_) {
      Timer(const Duration(seconds: 1), () {
        _btnController.error();
      });
    }
  }

  Widget _buildDuration() {
    return SizedBox(
      width: windowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 218, 223, 229)),
                borderRadius: BorderRadius.circular(5)),
            width: 80,
            height: 27,
            child: TextField(
              onChanged: (value) {
                _btnController.reset();
              },
              controller: _editingController,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: "输入间隔",
                border: InputBorder.none,
              ),
            ),
          ),
          RoundedLoadingButton(
            width: 80,
            height: 35,
            controller: _btnController,
            onPressed: _doSomething,
            child: const Text('确定', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildCountDownWidget() {
    return SizedBox(
      width: windowWidth,
      child: Center(
        child: CircularPercentIndicator(
            radius: 70,
            lineWidth: 5.0,
            percent: (settedDuration - duration) / settedDuration,
            center: Text("Remaining ${settedDuration - duration} Secs",
                style: const TextStyle(color: Color(0xFF535355))),
            linearGradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Color(0xFF1AB600), Color(0xFF6DD400)]),
            rotateLinearGradient: true,
            circularStrokeCap: CircularStrokeCap.round),
      ),
    );
  }
}
