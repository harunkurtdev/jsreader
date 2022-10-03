import 'dart:async';
import 'package:jsreader/jsreader.dart';

import 'jsreader_struct.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'dart:io' show Directory, Platform;

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
  late int number;
  late int value;
  late StreamController<JSButton> _streamControl;

  JoystickButton() {
    this._createButton = this
        .joystickLib
        .lookupFunction<CreateButtonNative, CreateButtons>('button');
    this._jsButton = JSButton();
    this._streamControl = StreamController();

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      this._jsButton.number = this._createButton().number;
      this.._jsButton.value = this._createButton().value;
      _streamControl.add(this._jsButton);
      print(this._jsButton);
    });
  }

  Stream<JSButton> get listenButton => _streamControl.stream;
}

// class Joystick extends getJoystick {
//   // final buttons = createButton();

//   late dynamic _createButton;
//   late JSButton _jsButton;
//   late int number;
//   late int value;
//   late StreamController<JSButton> _streamControl;

//   Joystick() {
//     this._createButton = this
//         .joystickLib
//         .lookupFunction<CreateJoystickNative, CreateJoystick>('axes');
//     this._jsButton = JSButton();
//     this._streamControl = StreamController();

//     Timer.periodic(Duration(milliseconds: 1), (timer) {
//       this._jsButton.number = this._createButton().axis;
//       this.._jsButton.value = this._createButton().x;
//       _streamControl.add(this._jsButton);
//       print(this._jsButton);
//     });
//   }

//   Stream<JSButton> get listenButton => _streamControl.stream;
// }

class JoystickAxes extends getJoystick {
  late dynamic _createAxes;
  late JSAxes _jsAxes;
  late int axis;
  late int x;
  late int y;

  late StreamController<JSAxes> _streamControl;

  JoystickAxes() {
    _createAxes =
        this.joystickLib.lookupFunction<CreateAxesNative, CreateAxes>('axes');
    this._jsAxes = JSAxes();
    this._streamControl = StreamController();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      // this._jsAxes.number = this._createAxes().number;
      // this.._jsButton.value = this._createAxes().value;

      this._jsAxes.axis = this._createAxes().axis;
      this.._jsAxes.x = this._createAxes().x;
      this.._jsAxes.y = this._createAxes().y;

      _streamControl.add(this._jsAxes);
      // print(this._jsAxes)
    });
  }

  Stream<JSAxes> get listenAxes => _streamControl.stream;
}

class getJoystick {
  late DynamicLibrary joystickLib;

  getJoystick() {
    var libraryPath =
        path.join('./tool/structs_library/build', 'libstructs.so');
    if (Platform.isMacOS) {
      libraryPath = path.join(
          Directory.current.path, 'structs_library', 'libstructs.dylib');
    }
    if (Platform.isWindows) {
      libraryPath = path.join(
          Directory.current.path, 'structs_library', 'Debug', 'structs.dll');
    }
    this.joystickLib = DynamicLibrary.open(libraryPath);
  }
}

typedef jsDevice = Pointer<Utf8> Function();

void main() {
  var joystickAxes = JoystickAxes();
  // var joystickAxes = Joystick();
  var joystickButton = JoystickButton();

  joystickButton.listenButton.listen((event) {
    print(event.number);
    print(event.value);
  });
  joystickAxes.listenAxes.listen((event) {
    print(event.toString());
    // print(event.number);
    // print(event.x);
    // print(event.y);
  });
}
