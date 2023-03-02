import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_planner/data.dart';
import 'package:auto_planner/filebar.dart';
import 'package:auto_planner/mainmenu.dart';

class ConnectionHandler {
  static final ConnectionHandler _singleton = ConnectionHandler();

  factory ConnectionHandler() {
    return _singleton;
  }

  static bool isConnected = false;

  static Socket? socket;

  static void connect(int teamNumber) async {
    String ip = '10.';
    String number = teamNumber.toString();
    if (number.length <= 2) {
      ip += '0.';
      ip += number;
      ip += '.2';
    }
    else if (number.length == 3) {
      ip += number[0];
      ip += '.';
      ip += number.substring(1,2);
      ip += '.2';
    }
    else {
      ip += number.substring(0,1);
      ip += '.';
      ip += number.substring(2,3);
      ip += '.2';
    }

    socket = await Socket.connect(ip, 5810);

    socket!.done.then((value) {
      MainMenuState.singleton.refreshState();
      FileBarState.singleton.refreshState();
    });

    isConnected = true;

    MainMenuState.singleton.refreshState();
    FileBarState.singleton.refreshState();
  }

  static void setProfile(String profile, Function? successHandler, Function? errorHandler) async {
    socket!.writeln(json.encode(Message(messageType: MessageType.Set, message: profile).toJson()));
    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.Set && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          }
          else if (success.type == MessageType.Set && success.successful) {
            if (successHandler != null) {
              successHandler();
            }
            return;
          }
        }
      }
    });
  }

  static Future<String> getCurrentProfile(Function? errorHandler) async {
    final data = Completer<String>();

    socket!.writeln(json.encode(Message(messageType: MessageType.Current).toJson()));

    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Current) {
          data.complete(message.message);
        }
        else if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.Current && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          } 
        }
      }
    });

    return await data.future;
  }

  static Future<List<String>> getProfileList(Function? errorHandler) async {
    final data = Completer<List<String>>();

    socket!.writeln(json.encode(Message(messageType: MessageType.List).toJson()));

    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.List) {
          data.complete(json.decode(message.message).cast<List<String>>());
        }
        else if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.List && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          } 
        }
      }
    });

    return await data.future;
  }

  static Future<AutoProfile> downloadProfile(Function? errorHandler) async {
    final data = Completer<AutoProfile>();

    socket!.writeln(json.encode(Message(messageType: MessageType.Download).toJson()));

    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Download) {
          data.complete(AutoProfile.fromJson(jsonDecode(message.message)));
        }
        else if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.Download && !success.successful) {
            errorHandler!();
            return;
          } 
        }
      }
    });

    return await data.future;
  }

  static void uploadProfile(AutoProfile upload, Function? successHandler, Function? errorHandler) async {
    socket!.writeln(json.encode(Message(messageType: MessageType.Upload, message: json.encode(upload.toJson())).toJson()));
    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.Upload && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          }
          else if (success.type == MessageType.Upload && success.successful) {
            if (successHandler != null) {
              successHandler();
            }
            return;
          }
        }
      }
    });
  }

  static void updateProfile(AutoProfile update, Function? successHandler, Function? errorHandler) async {
    socket!.writeln(json.encode(Message(messageType: MessageType.Update, message: json.encode(update.toJson())).toJson()));
    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.Update && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          }
          else if (success.type == MessageType.Update && success.successful) {
            if (successHandler != null) {
              successHandler();
            }
            return;
          }
        }
      }
    });
  }

  static Future<ActionData> downloadActionData(Function? errorHandler) async {
    final data = Completer<ActionData>();

    socket!.writeln(json.encode(Message(messageType: MessageType.ActionsDownload).toJson()));

    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.ActionsDownload) {
          data.complete(ActionData.fromJson(jsonDecode(message.message)));
        }
        else if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.ActionsDownload && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          } 
        }
      }
    });

    return await data.future;
  }

  static void uploadActionData(ActionData upload, Function? successHandler, Function? errorHandler) async {
    socket!.writeln(json.encode(Message(messageType: MessageType.ActionsUpload, message: json.encode(upload.toJson())).toJson()));
    socket!.listen((event) async {
      final stream = socket!.transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>);
      await for (final msg in stream) {
        Message message = Message.fromJson(jsonDecode(msg));
        if (message.messageType == MessageType.Success) {
          Success success = Success.fromJson(jsonDecode(message.message));
          if (success.type == MessageType.ActionsUpload && !success.successful) {
            if (errorHandler != null) {
              errorHandler();
            }
            return;
          }
          else if (success.type == MessageType.ActionsUpload && success.successful) {
            if (successHandler != null) {
              successHandler();
            }
            return;
          }
        }
      }
    });
  }
}

class Message {
  Message({this.messageType = MessageType.Success, this.message = ""});

  MessageType messageType;

  String message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageType'] = messageType;
    data['message'] = message;
    return data;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      messageType: json['messageType'],
    );
  }
}
enum MessageType {
  Set, //Set the active auto profile
  Upload, //A new auto profile from the controller
  Update, //An updated version of an auto profile from a controller
  Current, //Get the information about the current auto profile
  List, //Get all available auto profiles
  Download, //Send an auto profile to the controller
  
  ActionsDownload, //Send a list of the action definitions stored on the robot
  ActionsUpload, //Set the list of action definitions on the robot

  Success //Confirm or deny successful completion of a message
} 

class Success {
  Success({this.successful = false, this.type = MessageType.Success});

  bool successful;

  MessageType type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['successful'] = successful;
    data['type'] = type;
    return data;
  }

  factory Success.fromJson(Map<String, dynamic> json) {
    return Success(
      successful: json['successful'],
      type: json['type'],
    );
  }
}