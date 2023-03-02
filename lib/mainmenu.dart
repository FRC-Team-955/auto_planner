import 'dart:io';

import 'package:auto_planner/actionmenu.dart';
import 'package:auto_planner/connection.dart';
import 'package:auto_planner/filebar.dart';
import 'package:auto_planner/projectmenu.dart';
import 'package:auto_planner/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => MainMenuState.newState();
}

class MainMenuState extends State<MainMenu> {
  static MainMenuState singleton = MainMenuState();

  factory MainMenuState.newState() {
    MainMenuState object = MainMenuState();
    singleton = object;
    ConnectionHandler.connect(955);
    return object;
  }

  MainMenuState();

  void refreshState() {
    setState(() {});
  }

  void navigateToProject() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProjectMenu())
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ConnectionHandler.isConnected) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.red,
            title: const Text("Auto Planner"),
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [            
                    ListTile(
                      leading: const Icon(Icons.folder_rounded),
                      title: const Text("Open"),
                      onTap: () async {
                        Directory directory = await getApplicationDocumentsDirectory();
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          initialDirectory: '${directory.path}/autoPlanner/userData/profiles/',
                          type: FileType.custom,
                          allowedExtensions: <String>['auto'],
                        );
                        await StorageHandler.loadProfileAsync(result!.files.single.path!, (profile) => {
                          StorageHandler.loadedProfile = profile
                        });
                        navigateToProject();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.cloud_download_rounded),
                      title: const Text("Open From Robot"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.create_rounded),
                      title: const Text("New"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProjectMenu(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.red,
                    ),
                    const ListTile(
                      leading: Icon(Icons.cloud_rounded),
                      title: Text("Robot Manager"),
                    ),
                    ListTile(
                      leading: Icon(Icons.list_alt_rounded),
                      title: Text("Action Manager"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProjectMenu(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.red,
                    ),
                    const ListTile(
                      leading: Icon(Icons.settings_rounded),
                      title: Text("Settings"),
                    ),
                  ],
                ),
              ),
            ),
          ),]
        ),
      );
    }
    else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.red,
            title: const Text("Auto Planner"),
          )
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.folder_rounded),
                      title: const Text("Open"),
                      onTap: () async {
                        Directory directory = await getApplicationDocumentsDirectory();
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          initialDirectory: '${directory.path}/autoPlanner/userData/profiles/',
                          type: FileType.custom,
                          allowedExtensions: <String>['auto'],
                        );
                        await StorageHandler.loadProfileAsync(result!.files.single.path!, (profile) => {
                          StorageHandler.loadedProfile = profile
                        });
                        navigateToProject();
                      },
                    ),
                    const ListTile(
                      leading: Icon(Icons.wifi_off_rounded),
                      title: Text("Open From Robot"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.create_rounded),
                      title: const Text("New"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProjectMenu(),
                          ),
                        );                
                      },
                    ),
                    const Divider(
                      color: Colors.red,
                    ),
                    const ListTile(
                      leading: Icon(Icons.wifi_off_rounded),
                      title: Text("Robot Manager"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt_rounded),
                      title: const Text("Action Manager"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ActionMenu(),
                          ),
                        );                
                      },
                    ),
                    const Divider(
                      color: Colors.red,
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_rounded),
                      title: const Text("Settings"),
                      onTap: () {
                        
                      },
                    ),
                    TextButton(
                      child: Text('Connect'),
                      onPressed: () {
                        ConnectionHandler.connect(955);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),]
        ),
      );
    }
  }
}