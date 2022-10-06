import 'dart:async';
import 'package:jsreader/jsreader.dart';

import 'jsreader_struct.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'dart:io' show Directory, Platform;

import 'package:async/async.dart' show StreamGroup;
// Directory.current.path,

class JSButton {
  late int number;
  late int value;
  late int valuey;

  @override
  String toString() {
    // TODO: implement toString
    return "Joystick is button number ${this.number} and value ${this.value}, valuey ${this.valuey}";
  }
}

class JSAxes {
  late int axis;
  late int x;
  late int y;

  @override
  String toString() {
    // TODO: implement toString
    return "Joystick is axis ${this.axis} , x ${this.x} and ${this.y} ";
  }
}

class JoystickButton extends getJoystick {
  // final buttons = createButton();

  late dynamic _createButton;
  late JSButton _jsButton;
  late int number;
  late int value;
  late StreamController<JSButton> _streamButtonControl;
  late StreamController<JSAxes> _streamAxesControl;

  JoystickButton() {
    this._createButton = this
        .joystickLib
        .lookupFunction<CreateAxesNative, CreateAxes>('jsevent');
    this._jsButton = JSButton();
    this._streamButtonControl = StreamController();
    this._streamAxesControl = StreamController();

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (this._createButton().type == 1) {
      } else {}
      this._jsButton.number = this._createButton().axis;
      this.._jsButton.value = this._createButton().x;
      this.._jsButton.valuey = this._createButton().y;
      print(this._createButton().type);
      _streamControl.add(this._jsButton);
      // }
    });
  }

  Stream<JSButton> get listenButton => _streamControl.stream;
}

class getJoystick {
  late DynamicLibrary joystickLib;
  getJoystick() {
    var libraryPath = path.join('tool/structs_library/build', 'libstructs.so');
    if (Platform.isMacOS) {
      libraryPath = path.join(
          Directory.current.path, 'structs_library', 'libstructs.dylib');
    }
    if (Platform.isWindows) {
      libraryPath = path.join(
          Directory.current.path, 'structs_library', 'Debug', 'structs.dll');
    }
    this.joystickLib = new DynamicLibrary.open(libraryPath);
  }
}

typedef jsDevice = Pointer<Utf8> Function();

void main() {
  // var joystickAxes = JoystickAxes();
  var joystickButton = JoystickButton();

  joystickButton.listenButton.listen((event) {
    print(event.toString());
  });
}
