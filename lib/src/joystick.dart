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

  @override
  String toString() {
    // TODO: implement toString
    return "Joystick is button number ${this.number} and value ${this.value}";
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
  late JSAxes _jsAxes;
  late int number;
  late int value;
  late StreamController<JSButton> _streamButtonControl;
  late StreamController<JSAxes> _streamAxesControl;

  JoystickButton() {
    this._createButton = this
        .joystickLib
        .lookupFunction<CreateAxesNative, CreateAxes>('jsevent');
    this._jsButton = JSButton();
    this._jsAxes = JSAxes();
    this._streamButtonControl = StreamController();
    this._streamAxesControl = StreamController();

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      print(this._createButton().type);
      if (this._createButton().type == 1) {
        this._jsButton.number = this._createButton().axis;
        this.._jsButton.value = this._createButton().x;
        _streamButtonControl.add(this._jsButton);
      } else {
        try {
          this._jsAxes.axis = this._createButton().axis;
          this.._jsAxes.x = this._createButton().x;
          this.._jsAxes.y = this._createButton().y;
          _streamAxesControl.add(this._jsAxes);
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  Stream<JSButton> get listenButton => this._streamButtonControl.stream;
  Stream<JSAxes> get listenAxes => this._streamAxesControl.stream;
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
  joystickButton.listenAxes.listen((event) {
    print(event.toString());
  });
}
