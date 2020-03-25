import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'the_world.dart';

class NewtonsGame extends BaseGame  with TapDetector  {

  final TheWorld theWorld = TheWorld();
  Size size;

  NewtonsGame(Size size) {
    this.size = size;
    print("size: $size");
    theWorld.initializeWorld();
  }

  @override
  void render(Canvas canvas) {
    theWorld.render(canvas);
  }

  @override
  void update(double t) {
    theWorld.update(t);
  }

  @override
  void resize(Size size) {
    theWorld.resize(size);
  }

  @override
  void onTapUp(TapUpDetails details) {
    theWorld.handleTap(details.globalPosition);
    super.onTapUp(details);
  }

}
