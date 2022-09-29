import 'package:jsreader/jsreader.dart';

void main() {
  var button = JoystickButton();

  while (true) {
    button.getFiles();
    // print(button.createButton().number);
  }
  // button.listen((event) {
  //   print(event.number);
  // });
  // var awesome = Awesome();
  // print('awesome: ${awesome.isAwesome}');
}
