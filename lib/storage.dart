import 'dart:convert';
import 'dart:io';

import 'package:auto_planner/data.dart';
import 'package:path_provider/path_provider.dart';

class StorageHandler {
  static AutoProfile? loadedProfile; //use this to store it for loading the project menu

  static void storeProfile(AutoProfile profile, Function? successHandler) {
    _storeProfileAsync(profile, successHandler).then((value) => null);
  }

  static Future<void> _storeProfileAsync (AutoProfile profile, Function? successHandler) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/autoPlanner/userData/profiles/${profile.name}.auto').create(recursive: true);
    file.writeAsString(json.encode(profile.toJson()));
    if (successHandler != null) {
      successHandler();
    }
  }

  static void loadProfile(String name, Function(AutoProfile) onLoad) {
    loadProfileAsync(name, onLoad).then((value) => null);
  }

  static Future<void> loadProfileAsync (String path, Function(AutoProfile) onLoad) async {
    onLoad(AutoProfile.fromJson(json.decode(await File(path).readAsString())));
  }

  static void listProfiles(Function(List<String>) onList) {
    _listProfilesAsync(onList).then((value) => null);
  }

  static Future<void> _listProfilesAsync(Function(List<String>) onList) async {
    Directory directory = await getApplicationDocumentsDirectory();
    Directory profileDirectory = Directory('${directory.path}/autoPlanner/userData/profiles');
    List<File> profiles = await profileDirectory.list().where((e) => e is File).map((e) => e as File).toList();
    List<String> results = <String>[];
    for (int i = 0; i < profiles.length; i++) {
      results.add(profiles[i].path.split('/').last.split('.').first);
    }
    onList(results);
  }

  static void storeActionData(ActionData data, String name, Function? successHandler) {
    _storeActionDataAsync(data, name, successHandler).then((value) => null);
  }

  static Future<void> _storeActionDataAsync (ActionData data, String name, Function? successHandler) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/autoPlanner/userData/actionData/$name.auto').create(recursive: true);
    file.writeAsString(json.encode(data.toJson()));
    if (successHandler != null) {
      successHandler();
    }
  }

  static void loadActionData(String name, Function(ActionData) onLoad) {
    _loadActionDataAsync(name, onLoad).then((value) => null);
  }

  static Future<void> _loadActionDataAsync (String name, Function(ActionData) onLoad) async {
    Directory directory = await getApplicationDocumentsDirectory();
    onLoad(ActionData.fromJson(json.decode(await File('${directory.path}/autoPlanner/userData/actionData/$name.json').readAsString())));
  }

  static void listActionData(Function(List<String>) onList) {
    _listActionDataAsync(onList).then((value) => null);
  }

  static Future<void> _listActionDataAsync(Function(List<String>) onList) async {
    Directory directory = await getApplicationDocumentsDirectory();
    Directory profileDirectory = Directory('${directory.path}/autoPlanner/actionData/profiles');
    List<File> profiles = await profileDirectory.list().where((e) => e is File).map((e) => e as File).toList();
    List<String> results = <String>[];
    for (int i = 0; i < profiles.length; i++) {
      results.add(profiles[i].path.split('/').last.split('.').first);
    }
    onList(results);
  }
}