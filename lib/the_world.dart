import 'dart:async';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ball_component.dart';
import 'wall_body.dart';

class TheWorld extends Box2DComponent {
  static const double scale = 20.0;
  World world;

  List<BallComponent> balls = [];
  WallBody wall;

  Timer impulsTrigger;
  TheWorld() : super(scale: scale, gravity: 0);

  static const distanceBetweenBalls = 2.1;
  static const numberOfBalls = 5;

  void initializeWorld() {
    print("initializeWorld viewport: ${viewport.width} ${viewport.height}");
    world = World.withGravity(Vector2(0, -10));
    wall =
        WallBody(this, Orientation.landscape, 1.0, 0.05, Alignment.topCenter);
    add(wall);

    double x = 0 - (numberOfBalls / 2) * distanceBetweenBalls;
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var ball = BallComponent(this, Vector2(x, -viewport.height / 2 + 2));
      add(ball);
      balls.add(ball);
      var djd = DistanceJointDef();
      djd.frequencyHz = 10.0;
      djd.dampingRatio = 1.0;
      djd.initialize(wall.body, balls[ix].body, Vector2(x, viewport.height),
          Vector2(x, -viewport.height / 2 + 2));
      world.createJoint(djd);
      x += distanceBetweenBalls;
    }
    impulsTrigger = Timer(Duration(seconds: 3), () {
      pushBalls(3);
    });
  }

  void pushBalls(int count) {
    for (var nn = 0; nn < count; nn++) {
      balls[nn].impulse(Offset(-0.2, 0.0));
    }
  }

  @override
  void update(t) {
    super.update(t);
  }

  @override
  void render(canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, viewport.width * viewport.scale,
        viewport.height * viewport.scale);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff33aa33);
    canvas.drawRect(bgRect, bgPaint);
    super.render(canvas);
  }

  void handleTap(Offset position) {
    print("position: $position");
    balls.forEach((ball) {
      ball.stop();
    });
  }
}
