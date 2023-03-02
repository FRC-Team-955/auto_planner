import 'dart:io';
import 'dart:ui';

import 'package:auto_planner/mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(500, 300));
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(900, 600),
        center: true,
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      }
    );
  }

  runApp(const AutoPlanner());
}

class AutoPlanner extends StatelessWidget {
  const AutoPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Planner',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: const MainMenu(),
    );
  }
}