import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:auto_lock_windows/auto_lock_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _autoLockWindowsPlugin = AutoLockWindows();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _sub = _myStream.listen((event) {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _autoLockWindowsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    try {
      _sub.cancel();
    } catch (_) {}

    super.dispose();
  }

  late StreamSubscription _sub;

  late final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) async {
    final r = await _autoLockWindowsPlugin.getDuration();
    if (r > 60) {
      _autoLockWindowsPlugin.lockScreen();
      _sub.cancel();
    }
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
