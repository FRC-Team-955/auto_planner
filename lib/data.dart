// ignore_for_file: constant_identifier_names


import 'dart:ffi';

import 'package:flutter/material.dart';

class AutoProfile {
  String name = "Auto Profile";
  String description = "";
  Team team;
  List<AutoAction> Actions = <AutoAction>[];

  AutoProfile({this.name = "AutoProfile", this.description = "", required this.Actions, this.team = Team.Red}); //The actions list is required because you cannot add to a constant value, which has to happen with a value in a consructor unless it is required

  bool isTeamRed() {
    return (team == Team.Red);
  }

  void setIsRed(bool red) {
    if (red) {
      team = Team.Red;
    }
    else {
      team = Team.Blue;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['description'] = description;
    data['team'] = team.toString();
    data['Actions'] = Actions;
    return data;
  }

  factory AutoProfile.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonActions = json['Actions'];
    List<AutoAction> actions = <AutoAction>[];
    jsonActions.forEach((element) {
      actions.add(AutoAction.fromJson(element));
    });
    return AutoProfile(
      name: json['name'],
      description: json['description'],
      team: Team.values.firstWhere((e) => e.toString() == json['team']),
      Actions: actions
    );
  }
}

enum Team {
  Red,
  Blue
}

class AutoAction {
  String actionName = "Action";
  String codeName = "action";
  double startTime = 0;
  double endTime = 3;
  EarlyEndMode earlyMode = EarlyEndMode.End;
  LateEndMode lateMode = LateEndMode.Wait;
  Map<String, VariableInfo> variables = <String, VariableInfo>{};
  List<AutoAction> endActions = <AutoAction>[];
  bool endDeployed = false;

  AutoAction({this.actionName = "Action", this.codeName = "action", this.startTime = 0, this.endTime = 3, this.earlyMode = EarlyEndMode.End, this.lateMode = LateEndMode.Wait, 
    this.variables = const <String, VariableInfo>{}, required this.endActions}); //Same reason as above

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['actionName'] = actionName;
    data['@class'] = 'frc.robot.Auto.Actions.$codeName';
    data['variables'] = variables;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['earlyMode'] = earlyMode.toString();
    data['lateMode'] = lateMode.toString();
    data['endDeployed'] = false;
    for (var variable in variables.entries) {
      data[variable.key] = variable.value.value;
    }
    data['endActions'] = endActions;
    return data;
  }

  factory AutoAction.fromJson(Map<String, dynamic> json) {
    List<AutoAction> endActions = <AutoAction>[];
    (json['endActions'] as List<dynamic>).forEach((element) {
      endActions.add(AutoAction.fromJson(element));
    });

    Map<String, VariableInfo> variables = <String, VariableInfo>{};
    (json['variables'] as Map<String, dynamic>).entries.forEach((element) {
      variables[element.key] = VariableInfo.fromJson(element.value);
    });

    return AutoAction(
      actionName: json['actionName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      earlyMode: EarlyEndMode.values.firstWhere((e) => e.toString() == json['earlyMode']),
      lateMode: LateEndMode.values.firstWhere((e) => e.toString() == json['lateMode']),
      variables: variables,
      endActions: endActions
    );
  }

  static AutoAction newFromName(String name) {
    Map<String, VariableInfo> variables = <String, VariableInfo>{};

    for (int i = 0; i < ActionData.activeData!.actions[name]!.variables.length; i++) {
      String varName = ActionData.activeData!.actions[name]!.variables.entries.elementAt(i).key;
      VariableType varType = ActionData.activeData!.actions[name]!.variables.entries.elementAt(i).value;
      variables[varName] = VariableInfo(type: varType);
      switch (varType) {
        case VariableType.bool:
          variables[varName]!.value = false;
          break;

        case VariableType.double:
          variables[varName]!.value = 0;
          break;

        case VariableType.int:
          variables[varName]!.value = 0;
          break;

        case VariableType.string:
          variables[varName]!.value = "";
          break;
      }
    }

    return AutoAction(
      actionName: name,
      codeName: ActionData.activeData!.actions[name]!.codeName,
      variables: variables,
      endActions: <AutoAction>[],
    );
  }
}

enum LateEndMode {
  Wait, //Wait to start the dependents until the action returns true
  Continue, //Start the dependents at end time, but keep calling the action until it returns true
  Enforce, //Stop the action at end time and start the dependents
  Rely //Stop the action at end time and don't call dependents if not completed in time
}
enum EarlyEndMode {
  Continuous, //Keep calling the action until end time and start the dependents
  Minimumn, //Stop calling the action once it returns true, but wait until end time to start dependents
  End //Stop the action once it return true and start the dependents
}

class VariableInfo {
  VariableInfo({this.type = VariableType.bool, this.value});

  VariableType type;
  dynamic value;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type.toString();
    data['value'] = value;
    return data;
  }

  factory VariableInfo.fromJson(Map<String, dynamic> json) {
    return VariableInfo(type: VariableType.values.firstWhere((e) => e.toString() == json['type']), value: json['value']);
  }
}

enum VariableType {
  bool,
  int,
  double,
  string
}

class ActionInfo {
  ActionInfo({this.name = "", this.variables = const <String, VariableType>{}, this.codeName = "codeAction", this.timelineColor = const Color.fromARGB(255, 55, 55, 55)});

  String name = "Action";
  String codeName = "codeAction";
  Color timelineColor = const Color.fromARGB(255, 55, 55, 55);
  Map<String, VariableType> variables = <String, VariableType>{};

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['timelineColor'] = timelineColor;
    data['variables'] = variables;
    return data;
  }

  factory ActionInfo.fromJson(Map<String, dynamic> json) {
    return ActionInfo(
      name: json['name'],
      timelineColor: json['timelineColor'],
      variables: json['variables'],
    );
  }
}

class ActionData {
  ActionData({this.actions = const <String, ActionInfo>{}});

  Map<String, ActionInfo> actions = <String, ActionInfo>{};

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actions'] = actions;
    return data;
  }

  factory ActionData.fromJson(Map<String, dynamic> json) {
    return ActionData(
      actions: json['actions'],
    );
  }

  static ActionData? activeData = ActionData(
    actions: {
      "Score Action": ActionInfo(
        name: "Score Action",
        codeName: "ScoreAction",
        timelineColor: Colors.purple,
        variables: {
          "position": VariableType.int,
          "level": VariableType.int
        }
      ),
      "Waypoint Action": ActionInfo(
        name: "Waypoint Action",
        codeName: "WaypointAction",
        timelineColor: Colors.blue,
        variables: {
          "x": VariableType.double,
          "y": VariableType.double,
          "heading": VariableType.double,
          "speed": VariableType.double,
        }
      )
    }
  );
}

