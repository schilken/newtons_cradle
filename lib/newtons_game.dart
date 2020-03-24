import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'the_world.dart';

class DistanceGame extends Game  with TapDetector, PanDetector  {

  final TheWorld theWorld = TheWorld();
  Size size;

  DistanceGame(Size size) {
    this.size = size;
//    print("size: $size");
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
    theWorld.handleTap(details.globalPosition, down: true);
  }

  @override
  void onTapDown(TapDownDetails details) {
    theWorld.handleTap(details.globalPosition, down: false);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    theWorld.handleDragUpdate(details);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    theWorld.handleDragEnd(details);
  }

  
}
