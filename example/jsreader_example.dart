import 'dart:ffi';
// import 'dart:ffi/ffi.dart';,
import 'package:ffi/ffi.dart';

import 'package:jsreader/jsreader.dart';

import 'package:path/path.dart' as path;

void main() {
  var button = JoystickButton();
  button.getFiles();
  // var libraryPath = path.join("./tool/sturct_library/build", 'libstructs.so');
  // print(libraryPath);
  // final dylib = DynamicLibrary.open(libraryPath);

  // final helloWorld =
  //     dylib.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  // final message = helloWorld().toDartString();
  // print(message);
  var dylib = getJoystick().joystickLib;
  // final jsdevice = dylib!.lookupFunction<jsDevice, jsDevice>('jsDevice');
  // final messageJs = jsdevice().toDartString();
  // print(messageJs);

  final createButton =
      dylib.lookupFunction<CreateButtonNative, CreateButtons>('button');

  final createAxes = dylib.lookupFunction<CreateAxesNative, CreateAxes>('axes');

  while (true) {
    // final buttons = createButton();
    final axes = createAxes();
    // print('button is number ${buttons.number}, value ${buttons.value}');
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
