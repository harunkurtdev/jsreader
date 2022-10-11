// import 'package:jsreader/jsreader.dart' as jsreader;

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

class MyStruct extends Struct {
  @UnsignedLong()
  external int a;

  @Short()
  external int b;

  @Char()
  external int c;

  @Char()
  external int d;

  // external Pointer<Void> c;
}

class parser {
  late Uint32 time;
  late Uint16 value;
  late Uint8 type;
  late Uint8 number;
}

void main(List<String> arguments) async {
  print(Platform.operatingSystem);
  if (Platform.isAndroid || Platform.isLinux) {
    File myFile = File('/dev/input/js0');
    myFile.open();
    // myFile.rename('yourFile.txt').then((_) => print('file renamed'));
    print(myFile.toString());
    var streamFile = await myFile.openRead();
    streamFile.listen((event) {
      // print(event);
      Int32List ret = Int32List(event.length);
      for (var i = 0; i < event.length; i++) {
        // ret[i] =
        ret[i] = event[i];
        print(ret[i]);
        //     event.buffer.asByteData().getInt32(0 + (i * 4), Endian.little);
      }

      print(ret);
    });
    var myreader = await myFile.readAsBytesSync();

    // myreader.buffer.asByteData().getInt32(myreader.)
    // final stm = Stream.fromIterable(streamFile).listen((event) {
    //   print(event.toString());
    // });
    // // print();
    // // var streamFilex =
    // //     myFile.readAsBytes().then((value) => print(value.toString()));
    // Int32List ret = Int32List(myreader.length);
    // for (var i = 0; i < myreader.length; i++) {
    //   ret[i] =
    //       myreader.buffer.asByteData().getInt32(0 + (i * 4), Endian.little);
    // }

    // print(ret);
    await myFile.exists();
  }
}
