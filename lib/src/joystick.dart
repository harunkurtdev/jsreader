import 'dart:async';
import 'jsreader_struct.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';
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

class JoystickAxes extends Stream {
  @override
  StreamSubscription listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // TODO: implement listen
    throw UnimplementedError();
  }
}

void main() {
  var button = JoystickButton();
  button.getFiles();
  var libraryPath = path.join(Directory.current.path, "tool", 'libstructs.so');
  print(libraryPath);
  final dylib = DynamicLibrary.open(libraryPath);
  final createButton =
      dylib.lookupFunction<CreateButtonNative, CreateButtons>('button');
  while (true) {
    // print(button.createButton().number);
  }
  // button.listen((event) {
  //   print(event.number);
  // });
  // var awesome = Awesome();
  // print('awesome: ${awesome.isAwesome}');
}
