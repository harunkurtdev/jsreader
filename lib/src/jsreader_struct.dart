// TODO: Put public facing types in this file.

import "dart:ffi";

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

class Button extends Struct {
  // Read Joystick Button from read kernel Byte at This Struct
  // with C language from joystick

  @Int()
  external int number;

  @Int()
  external int value;
}

class Axes extends Struct {
  // Read Joystick Axes from read kernel Byte at This Struct
  // with C language from joystick

  @Int()
  external int axis;

  @Int()
  external int x;

  @Int()
  external int y;
}

typedef CreateButtonNative = Button Function();
typedef CreateButtons = Button Function();

typedef CreateAxesNative = Axes Function();
typedef CreateAxes = Axes Function();
