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
  List<Vector2> ankerPoints = [];

  WallBody wall;

  Timer impulsTrigger;
  TheWorld() : super(scale: scale, gravity: 0);

  static const distanceBetweenBalls = 2.1;
  static const numberOfBalls = 5;

  void initializeWorld() {
    print("initializeWorld viewport: ${viewport.width} ${viewport.height}");
    world = World.withGravity(Vector2(0, -10));
    wall = WallBody(this, viewport.width, 2, Alignment.topCenter);
    add(wall);

    double x = 0 - (numberOfBalls / 2) * distanceBetweenBalls;
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var ball = BallComponent(this, Vector2(x, -viewport.height / 2 + 2));
      add(ball);
      balls.add(ball);
      ankerPoints.add(Vector2(x, viewport.height/2 - 2));
      var ballPosition = Vector2(x, -viewport.height / 2 + 2);
      var djd = DistanceJointDef();
      djd.frequencyHz = 10.0;
      djd.dampingRatio = 1.0;
      djd.initialize(wall.body, balls[ix].body, ankerPoints[ix], ballPosition);
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

    Paint linePaint = Paint();
    linePaint.color = Color(0xff888888);
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var p1 = worldVector2ToScreenOffset(ankerPoints[ix]);
      var p2 = worldVector2ToScreenOffset(balls[ix].body.position);
      //print("p1->p2 $p1->$p2");
      canvas.drawLine(p1, p2, linePaint);
    }
    super.render(canvas);
  }

  Offset screenOffsetToWorldOffset(Offset position) {
    return Offset(position.dx / scale - viewport.width / 2,
        viewport.height / 2 - position.dy / scale);
  }

  Offset worldVector2ToScreenOffset(Vector2 position) {
    return Offset((position.x + viewport.width / 2) * scale,
        (viewport.height / 2 - position.y) * scale);
  }

  void handleTap(Offset position) {
    print("position: $position");
    balls.forEach((ball) {
      ball.stop();
    });

    for (var nn = 0; nn < balls.length; nn++) {
      if (balls[nn].checkTapOverlap(screenOffsetToWorldOffset(position))) {
        pushBalls(nn + 1);
      }
    }
  }
}
