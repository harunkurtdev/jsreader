import 'dart:async';
import 'package:jsreader/jsreader.dart';

import 'jsreader_struct.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'dart:io' show Directory, Platform;

import 'package:async/async.dart' show StreamGroup;
// Directory.current.path,

class JS_Stream {
  late JoystickAxes _joystickAxes;
  late JoystickButton _joystickButton;
  late StreamController _streamController;

  JS_Stream() {
    _joystickAxes = JoystickAxes();
    _joystickButton = JoystickButton();
    _streamController = StreamController();
    // Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   _joystickAxes.listenAxes.listen((event) {});
    // });
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      // _joystickAxes.listenAxes.listen((event) {
      _joystickButton.listenButton.listen((event) {
        print(event.toString());
      });
      // });
    });
  }
}

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
  late StreamController<JSButton> _streamControl;

  JoystickButton() {
    this._createButton = this
        .joystickLib
        .lookupFunction<CreateAxesNative, CreateAxes>('jsevent');
    this._jsButton = JSButton();
    this._streamControl = StreamController();

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      // while (timer.isActive) {
      this._jsButton.number = this._createButton().axis;
      this.._jsButton.value = this._createButton().x;
      this.._jsButton.valuey = this._createButton().y;
      // print(this._createButton().y);
      // _streamControl.onResume;
      _streamControl.add(this._jsButton);
      // }
    });
  }

  Stream<JSButton> get listenButton => _streamControl.stream;
}

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
      print("bizde sıra");
      var a = this._createAxes().axis;

      if (a != null) {
        this._jsAxes.axis = a;
        this.._jsAxes.x = this._createAxes().x;
        this.._jsAxes.y = this._createAxes().y;
        print(_jsAxes.toString());
        _streamControl.add(this._jsAxes);
      } else {
        // _streamControl.onResume;
      }
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
  // joystickAxes.listenAxes;
  // StreamGroup.merge(streams)

  // StreamGroup streamGroup = StreamGroup<dynamic>.merge(
  //     [joystickAxes.listenAxes, joystickButton.listenButton]);
  // joystickAxes.listenAxes.listen((event) {
  //   print(event.toString());
  // });

  // streamGroup.stream.listen((event) {
  //   print(event.runtimeType);
  // });
}
