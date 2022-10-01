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
}

class JSAxes {
  late int axis;
  late int x;
  late int y;
}

class JoystickButton extends getJoystick {
  // final buttons = createButton();

  late dynamic _createButton;
  late JSButton _jsButton;
  late int number;
  late int value;

  JoystickButton() {
    this._createButton = this
        .joystickLib
        .lookupFunction<CreateButtonNative, CreateButtons>('button');
    this._jsButton = JSButton();
  }

  void getButton() {
    this.number = this._createButton().number;
    this.value = this._createButton().value;
  }

  Stream<JSButton> listenButton() async* {
    for (;;) {
      this._jsButton.number = this._createButton().number;
      this.._jsButton.value = this._createButton().value;

      yield this._jsButton;
    }
  }
}

class JoystickAxes extends getJoystick {
  late dynamic _createAxes;
  late JSAxes _jsAxes;
  late int axis;
  late int x;
  late int y;

  JoystickAxes() {
    _createAxes =
        this.joystickLib.lookupFunction<CreateAxesNative, CreateAxes>('axes');
    this._jsAxes = JSAxes();
  }

  void getAxes() {
    this.axis = this._createAxes().axis;
    this.x = this._createAxes().x;
    this.y = this._createAxes().y;
  }

  Stream<JSAxes> listenAxes() async* {
    for (;;) {
      this._jsAxes.axis = this._createAxes().axis;
      this.._jsAxes.x = this._createButton().x;
      this.._jsAxes.y = this._createButton().y;

      yield this._jsAxes;
    }
  }
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

  // getJoystick get getLibrary {}
}

typedef jsDevice = Pointer<Utf8> Function();

void main() {
  // final helloWorld =
  //     dylib.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  // final message = helloWorld().toDartString();
  // print(message);
  // var dylib = getJoystick().joystickLib;
  // final jsdevice = dylib.lookupFunction<jsDevice, jsDevice>('jsDevice');
  // final messageJs = jsdevice().toDartString();
  // print(messageJs);
  // var button = JoystickButton();
  // button.getFiles();
  // var libraryPath = path.join("./tool/sturct_library/build", 'libstructs.so');
  // print(libraryPath);
  // final dylib = DynamicLibrary.open(libraryPath);
// final createButton =
  //     dylib.lookupFunction<CreateButtonNative, CreateButtons>('button');

  //----------------

  var joystickAxes = JoystickAxes();
  var joystickButton = JoystickButton();
  joystickButton.listenButton().listen((event) {
    print(event.number);
    print(event.value);
  });
  // while (true) {
  //   joystickAxes.getAxes();
  //   print(
  //       'axes is number ${joystickAxes.axis}, value x ${joystickAxes.x} ,value y ${joystickAxes.y} ');

  //   // joystickButton.getButton();
  //   // print(
  //   //     'button is number ${joystickButton.number}, value ${joystickButton.value}');

  //   Future.delayed(Duration(milliseconds: 100));
  // }
}
