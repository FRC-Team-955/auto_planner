import 'package:auto_planner/data.dart';
import 'package:auto_planner/filebar.dart';
import 'package:auto_planner/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProjectMenu extends StatefulWidget {
  const ProjectMenu({super.key, this.profile});

  final AutoProfile? profile;

  final double fieldWidth = 651.25;
  final double fieldHeight = 315.5;

  @override
  State<ProjectMenu> createState() => ProjectMenuState();
}

class ProjectMenuState extends State<ProjectMenu> {
  ProjectMenuState();

  double splitX = 0.5;
  double splitY = 0.6;

  static AutoProfile profile = AutoProfile(Actions: <AutoAction>[]);
  ActionData actionData = ActionData();

  List<int> selections = [];

  AutoAction? oldSelection;

  //TextEditingController startTimeController = TextEditingController();
  //TextEditingController endTimeController = TextEditingController();

  String selectedNewChild = ActionData.activeData!.actions.entries.elementAt(0).key;

  //List<TextEditingController> editors = <TextEditingController>[];

  void navigateChild(int childId) {
    setState(() {
      selections.add(childId);
    });
  }

  void navigateParent() {
    setState(() {
      selections.removeLast();
    });
  }

  void navigateTop() {
    setState(() {
      selections.removeRange(0, selections.length - 1);
    });
  }

  AutoAction? getFromProfile(List<int> location) {
    if (selections.isEmpty) {
      return null;
    }
    AutoAction action = profile.Actions[location[0]];
    for (int i = 1; i < location.length; i++) {
      action = action.endActions[location[i]];
    }
    return action;
  }

  AutoAction? getParent() {
    List<int> location = selections;
    location.removeLast();
    return getFromProfile(location);
  }

  bool hasLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!hasLoaded) {
      hasLoaded = true;
      if (StorageHandler.loadedProfile != null) {
        profile = StorageHandler.loadedProfile!;
        StorageHandler.loadedProfile = null;
      }
      else {
        profile = AutoProfile(Actions: <AutoAction>[]);
      }
    }

    double height = MediaQuery.of(context).size.height - 50;
    
    AutoAction? selection;

    selection = getFromProfile(selections);

    List<Widget> actionInspector = [];

    actionInspector.add(const SizedBox(
      height: 30,
    ));

    if (selection != null) {
      actionInspector.add(Text(selection.actionName));
      actionInspector.add(ListTile(
        key: UniqueKey(),
        leading: const SizedBox(
          width: 175,
          child: Text(
            "Start Time",
            overflow: TextOverflow.fade,
        )),
        title: TextFormField (
          key: UniqueKey(),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
          initialValue: selection.startTime.toString(),
          onChanged: (String value) {
            if (!value.characters.contains('.')) {
              value = '$value.';
            }
            selection!.startTime = double.parse(value);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          //controller: startTimeController,
        )
      ));
      actionInspector.add(ListTile(
        key: UniqueKey(),
        leading: const SizedBox(
          width: 175,
          child: Text(
            "End Time",
            overflow: TextOverflow.fade,
        )),
        title: TextFormField(
          key: UniqueKey(),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
          initialValue: selection.endTime.toString(),
          onChanged: (String value) {
            if (!value.characters.contains('.')) {
              value = '$value.';
            }
            selection!.endTime = double.parse(value);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          //controller: endTimeController,
          )
      ));
      actionInspector.add(ListTile(
        key: UniqueKey(),
        leading: const SizedBox(
          width: 175,
          child: Text(
            "Early End Mode",
            overflow: TextOverflow.fade,
        )),
        title: DropdownButtonFormField<EarlyEndMode>(
          key: UniqueKey(),
          value: selection.earlyMode,
          onChanged: (EarlyEndMode? newMode) {
            setState(() {
              selection!.earlyMode = newMode!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: EarlyEndMode.Continuous,
              child: Tooltip(
                message: "Keep calling the action until end time and start the dependents",
                child: Text("Continuous"),
              )
            ),
            DropdownMenuItem(
              value: EarlyEndMode.End,
              child: Tooltip(
                message: "Stop the action once it return true and start the dependents",
                child: Text("End"),
              )
            ),
            DropdownMenuItem(
              value: EarlyEndMode.Minimumn,
              child: Tooltip(
                message: "Stop calling the action once it returns true, but wait until end time to start dependents",
                child: Text("Minimumn"),
              )
            )
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
      ));
      actionInspector.add(ListTile(
        key: UniqueKey(),
        leading: const SizedBox(
          width: 175,
          child: Text(
            "Late End Mode",
            overflow: TextOverflow.fade,
        )),
        title: DropdownButtonFormField<LateEndMode>(
          key: UniqueKey(),          
          value: selection.lateMode,
          onChanged: (LateEndMode? newMode) {
            setState(() {
              selection!.lateMode = newMode!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: LateEndMode.Continue,
              child: Tooltip(
                message: "Start the dependents at end time, but keep calling the action until it returns true",
                child: Text("Continue"),
              )
            ),
            DropdownMenuItem(
              value: LateEndMode.Enforce,
              child: Tooltip(
                message: "Stop the action at end time and start the dependents",
                child: Text("Enforce"),
              )
            ),
            DropdownMenuItem(
              value: LateEndMode.Rely,
              child: Tooltip(
                message: "Stop the action at end time and don't call dependents if not completed in time",
                child: Text("Rely"),
              )
            ),
            DropdownMenuItem(
              value: LateEndMode.Wait,
              child: Tooltip(
                message: "Wait to start the dependents until the action returns true",
                child: Text("Wait"),
              )
            )
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
      ));

      //editors.clear();

      for (int i = 0; i < selection.variables.length; i++) {
        //editors.add(TextEditingController());

        switch (selection.variables.entries.elementAt(i).value.type) {
          case VariableType.bool:
            actionInspector.add(ListTile(
              key: UniqueKey(),
              leading: SizedBox(
                width: 175,
                child: Text(
                  selection.variables.entries.elementAt(i).key,
                  overflow: TextOverflow.fade,
              )),
              title: Switch(
                key: UniqueKey(),
                value: selection.variables.entries.elementAt(i).value.value,
                onChanged: (bool value) {
                  setState(() {
                    selection!.variables.entries.elementAt(i).value.value = value;
                  });
                },
              ),
            ));
            break;

          case VariableType.int:
            actionInspector.add(ListTile(
              key: UniqueKey(),
              leading: SizedBox(
                width: 175,
                child: Text(
                  selection.variables.entries.elementAt(i).key,
                  overflow: TextOverflow.fade,
              )),
              title: TextFormField(
                key: UniqueKey(),
                initialValue: selection.variables.entries.elementAt(i).value.value.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: false,
                ),
                //controller: editors[i],
                onChanged: (value) {
                  //setState(() {
                    selection!.variables.entries.elementAt(i).value.value = int.parse(value);                    
                  //});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ));
            break;

          case VariableType.double:
            actionInspector.add(ListTile(
              key: UniqueKey(),
              leading: SizedBox(
                width: 175,
                child: Text(
                  selection.variables.entries.elementAt(i).key,
                  overflow: TextOverflow.fade,
              )),
              title: TextFormField(
                key: UniqueKey(),
                initialValue: selection.variables.entries.elementAt(i).value.value.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                //controller: editors[i],
                onChanged: (value) {
                  if (!value.characters.contains('.')) {
                    value = '$value.0';
                  }
                  //setState(() {
                    selection!.variables.entries.elementAt(i).value.value = double.parse(value);                    
                  //});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ));
            break;

          case VariableType.string:
            actionInspector.add(ListTile(
              key: UniqueKey(),
              leading: SizedBox(
                width: 175,
                child: Text(
                  selection.variables.entries.elementAt(i).key,
                  overflow: TextOverflow.fade,
              )),
              title: TextFormField(
                key: UniqueKey(),
                initialValue: selection.variables.entries.elementAt(i).value.value,
                keyboardType: TextInputType.text,
                //controller: editors[i],
                onChanged: (value) {
                  //setState(() {
                    selection!.variables.entries.elementAt(i).value.value = value;                    
                  //});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ));
            break;
        }
      }
      /*
      List<Widget> childActions = <Widget>[];

      for (int i = 0; i < selection.endActions.length; i++) {
        childActions.add(ListTile(
          title: Text(selection.endActions[i].actionName),
          onTap: () {
            navigateChild(i);
          },
        ));
      }

      List<DropdownMenuItem<String>> newChildOptions = <DropdownMenuItem<String>>[];

      for (int i = 0; i < ActionData.activeData!.actions.length; i++) {
        newChildOptions.add(DropdownMenuItem(
          value: ActionData.activeData!.actions.entries.elementAt(i).value.name,
        child: Text(ActionData.activeData!.actions.entries.elementAt(i).value.name),
        ));
      }

      childActions.add(ListTile(
        title: DropdownButton<String>(
          value: selectedNewChild,
          onChanged: (String? newActionType) {
            setState(() {
              selectedNewChild = newActionType!;
            });
          },
          items: newChildOptions,
        ),
        trailing: TextButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            selection!.endActions.add(AutoAction.newFromName(selectedNewChild));
            setState(() {});
          },
        ),
      ));

      actionInspector.add(SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: childActions,
          )
        )
      ));
      */
    }    

    

    List<Widget> timeline = <Widget>[];

    timeline.add(ListTile(
      leading: (selections.isNotEmpty)? TextButton(
        onPressed:() => navigateParent(),
        child: const Icon(Icons.arrow_back_rounded),
      ) : const TextButton(
        onPressed: null,
        child: Icon(Icons.arrow_back_rounded),
      ),
      title: (selections.isNotEmpty)? Text(selection!.actionName) : const Text('Profile'),
    ));
    List<AutoAction> timelineActions = (selections.isEmpty)? profile.Actions : getFromProfile(selections)!.endActions; 
    for (int i = 0; i < timelineActions.length; i++) {
      timeline.add(
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            color: Colors.grey,
            child: GestureDetector(
              onTap: () => navigateChild(i),
              child: Row(
                children: [
                  Expanded(
                    flex: (timelineActions[i].startTime * 100).round(),
                    child: Container(),
                  ),
                  Expanded(
                    flex: ((timelineActions[i].endTime - timelineActions[i].startTime) * 100).round(),
                    child: Container(
                      color: ActionData.activeData!.actions[timelineActions[i].actionName]!.timelineColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(timelineActions[i].actionName),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((15 - timelineActions[i].endTime) * 100).round(),
                    child: Container(),
                  ),
                ],
              )
            )
          ),
        ),        
      );
    }

    List<DropdownMenuItem<String>> newChildOptions = <DropdownMenuItem<String>>[];

    for (int i = 0; i < ActionData.activeData!.actions.length; i++) {
      newChildOptions.add(DropdownMenuItem(
        value: ActionData.activeData!.actions.entries.elementAt(i).value.name,
        child: Text(ActionData.activeData!.actions.entries.elementAt(i).value.name),
      ));
    }

    timeline.add(ListTile(
      title: DropdownButtonFormField<String>(
        value: selectedNewChild,
        onChanged: (String? newActionType) {
          setState(() {
            selectedNewChild = newActionType!;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: newChildOptions,
      ),
      trailing: TextButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          if (selection != null) {
            selection.endActions.add(AutoAction.newFromName(selectedNewChild));            
          }
          else {
            profile.Actions.add(AutoAction.newFromName(selectedNewChild));
          }
          setState(() {});
        },
      ),
    ));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          backgroundColor: (profile.isTeamRed()) ? Colors.red : Colors.blue,
          title: SizedBox (
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextFormField(
                  key: UniqueKey(),
                  textAlignVertical: TextAlignVertical.center,
                  initialValue: profile.name,
                  keyboardType: TextInputType.text,
                  //controller: editors[i],
                  onChanged: (value) {
                    //setState(() {
                      profile.name = value;                    
                    //});
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(17),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                key: UniqueKey(),
                activeColor: Colors.grey,
                inactiveTrackColor: Colors.grey,
                thumbColor: const MaterialStatePropertyAll(Colors.white),
                inactiveThumbColor: Colors.white,
                value: profile.isTeamRed(),
                onChanged: (bool value) {
                  setState(() {
                    profile.setIsRed(value);
                  });
                },
              ),
            ]),
          ),
        )
      ),
      drawer: const FileBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: Column(
          children: [
            SizedBox(
              height: height * (splitY - 0.005),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (splitX - 0.005),
                    child: SingleChildScrollView (
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: actionInspector,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: GestureDetector(
                      child: const VerticalDivider(
                        color: Colors.grey,
                        thickness: 10,                      
                      ),
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          splitX = clampDouble(splitX + (details.delta.dx / MediaQuery.of(context).size.width), 0.3, 0.7);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 16 - (MediaQuery.of(context).size.width * (splitX - 0.005)),
                    child: Container (
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('assets/Charged Up 2023 Field.png'),
                    )
                  )
                ]
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                child: const Divider(
                  thickness: 10, 
                  color: Colors.grey,                     
                ),
                onVerticalDragUpdate: (details) {
                  setState(() {
                    splitY = clampDouble(splitY + (details.delta.dy / height), 0.3, 0.7);
                  });
                },
              ),
            ),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: timeline,
                    )
                  ),
                )
              ),
            )
          ]
        ),
      ),
    );
  }
}//End