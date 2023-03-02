import 'package:flutter/material.dart';

class ActionMenu extends StatefulWidget {
  const ActionMenu({super.key});

  @override
  State<ActionMenu> createState() => ActionMenuState();
}

class ActionMenuState extends State<ActionMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Action Editor")
        ),
      ),
    );
  }
}