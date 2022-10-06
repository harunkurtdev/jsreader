import 'dart:ffi';
// import 'dart:ffi/ffi.dart';,
import 'package:ffi/ffi.dart';

import 'package:jsreader/jsreader.dart';

import 'package:path/path.dart' as path;

void main() {
  var joystickButton = JoystickButton();

  joystickButton.listenButton.listen((event) {
    print(event.toString());
  });
}
