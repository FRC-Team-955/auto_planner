import 'dart:io';

import 'package:auto_planner/connection.dart';
import 'package:auto_planner/filebar.dart';
import 'package:auto_planner/projectmenu.dart';
import 'package:auto_planner/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'mainmenu.dart';

class FileBar extends StatefulWidget {
  const FileBar({super.key});

  @override
  State<StatefulWidget> createState() => FileBarState.newState();
}

class FileBarState extends State<FileBar> {
  static FileBarState singleton = FileBarState();

  factory FileBarState.newState() {
    FileBarState state = FileBarState();
    singleton = state;
    return state;
  }

  FileBarState();

  void refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (ConnectionHandler.isConnected) {
      return Drawer(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.menu_rounded),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_rounded),
                title: const Text("Save"),
                onTap: () {
                  StorageHandler.storeProfile(ProjectMenuState.profile, null);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.save_as_rounded),
              //   title: const Text("Save As"),
              //   onTap: () {
                  
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.cloud_sync_rounded),
                title: const Text("Save To Robot"),
                onTap: () {
                  StorageHandler.storeProfile(ProjectMenuState.profile, null);
                  ConnectionHandler.uploadProfile(ProjectMenuState.profile, null, null);
                  ConnectionHandler.updateProfile(ProjectMenuState.profile, null, null);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.cloud_upload_rounded),
              //   title: const Text("Save To Robot As"),
              //   onTap: () {
                  
              //   },
              // ),
              const Divider(
                color: Colors.red,
              ),
              ListTile(
                leading: const Icon(Icons.folder_rounded),
                title: const Text("Open"),
                onTap: () async {
                  StorageHandler.storeProfile(ProjectMenuState.profile, null);
                  Directory directory = await getApplicationDocumentsDirectory();
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    initialDirectory: '${directory.path}/autoPlanner/userData/profiles/',
                    type: FileType.custom,
                    allowedExtensions: <String>['auto'],
                  );
                  await StorageHandler.loadProfileAsync(result!.files.single.path!, (profile) => {
                    StorageHandler.loadedProfile = profile
                  });
                  MainMenuState.singleton.navigateToProject();
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
                    StorageHandler.storeProfile(ProjectMenuState.profile, null);
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
              ListTile(
                leading: const Icon(Icons.cloud_done_rounded),
                title: const Text("Set As Active Auto"),
                onTap: () {
                  ConnectionHandler.uploadProfile(ProjectMenuState.profile, null, null);
                  ConnectionHandler.updateProfile(ProjectMenuState.profile, null, null);
                  ConnectionHandler.setProfile(ProjectMenuState.profile.name , null, null);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_rounded),
                title: const Text("Robot Manager"),
                onTap: () {
              
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt_rounded),
                title: const Text("Action Manager"),
                onTap: () {
                  
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
            ],
          ),
        )
      );
    }
    else {
      return Drawer(
        child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  trailing: const Icon(Icons.menu_rounded),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.save_rounded),
                  title: const Text("Save"),
                  onTap: () {
                    StorageHandler.storeProfile(ProjectMenuState.profile, null);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.save_as_rounded),
                //   title: const Text("Save As"),
                //   onTap: () {
                    
                //   },
                // ),
                const ListTile(
                  leading: Icon(Icons.wifi_off_rounded),
                  title: Text("Save To Robot"),
                ),
                // const ListTile(
                //   leading: Icon(Icons.wifi_off_rounded),
                //   title: Text("Save To Robot As"),
                // ),
                const Divider(
                  color: Colors.red,
                ),
                ListTile(
                  leading: const Icon(Icons.folder_rounded),
                  title: const Text("Open"),
                  onTap: () async {
                    StorageHandler.storeProfile(ProjectMenuState.profile, null);
                    Directory directory = await getApplicationDocumentsDirectory();
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      initialDirectory: '${directory.path}/autoPlanner/userData/profiles/',
                      type: FileType.custom,
                      allowedExtensions: <String>['auto'],
                    );
                    await StorageHandler.loadProfileAsync(result!.files.single.path!, (profile) => {
                      StorageHandler.loadedProfile = profile
                    });
                    MainMenuState.singleton.navigateToProject();
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
                    StorageHandler.storeProfile(ProjectMenuState.profile, null);
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
                  title: Text("Set As Active Auto"),
                ),
                const ListTile(
                  leading: Icon(Icons.wifi_off_rounded),
                  title: Text("Manage Robot Autos"),
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt_rounded),
                  title: const Text("Manage Auto Actions"),
                  onTap: () {
                    
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
        )
      );
    }
  }
}
