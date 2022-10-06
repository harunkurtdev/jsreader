import 'dart:ffi';
// import 'dart:ffi/ffi.dart';,
import 'package:ffi/ffi.dart';

import 'package:jsreader/jsreader.dart';

import 'package:path/path.dart' as path;

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
