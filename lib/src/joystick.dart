import 'dart:async';
import 'package:jsreader/jsreader.dart';

import 'jsreader_struct.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'dart:io' show Directory, Platform;

// Directory.current.path,

class JoystickButton extends Stream {
  // final buttons = createButton();
  void getFiles() {
    print(Directory.current.path);
  }

  @override
  StreamSubscription listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // TODO: implement listen

    throw UnimplementedError();
  }
}

class JoystickAxes extends getJoystick {
  late dynamic _createAxes;
  JoystickAxes() {
    _createAxes =
        this.joystickLib.lookupFunction<CreateAxesNative, CreateAxes>('axes');
  }

  void getAxes() {}
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
  // var button = JoystickButton();
  // button.getFiles();
  // var libraryPath = path.join("./tool/sturct_library/build", 'libstructs.so');
  // print(libraryPath);
  // final dylib = DynamicLibrary.open(libraryPath);

  // final helloWorld =
  //     dylib.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  // final message = helloWorld().toDartString();
  // print(message);
  var dylib = getJoystick().joystickLib;
  final jsdevice = dylib.lookupFunction<jsDevice, jsDevice>('jsDevice');
  final messageJs = jsdevice().toDartString();
  print(messageJs);

  final createButton =
      dylib.lookupFunction<CreateButtonNative, CreateButtons>('button');

  while (true) {
    // final buttons = createButton(); print('button is number ${buttons.number}, value ${buttons.value}');

    final axes = createAxes();
    print('axes is number ${axes.axis}, value x ${axes.x} ,value y ${axes.y} ');

    Future.delayed(Duration(milliseconds: 100));
  }

  // final createButton =
  //     dylib.lookupFunction<CreateButtonNative, CreateButtons>('button');
  // while (true) {
  //   // print(button.createButton().number);
  // }
  // button.listen((event) {
  //   print(event.number);
  // });
  // var awesome = Awesome();
  // print('awesome: ${awesome.isAwesome}');
}
