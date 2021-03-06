import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ball_component.dart';
import 'dummy_body.dart';

class TheWorld extends Box2DComponent implements ContactListener {
  static const double scale = 20.0;
  World world;

  List<BallComponent> balls;
  List<Vector2> ankerPoints;

  DummyBody wall;
  //FlameAudio audio = FlameAudio();

  Timer impulsTrigger;
  TheWorld() : super(dimensions: window.physicalSize, scale: scale, gravity: 0);

  static const distanceBetweenBalls = 2.02;
  static const numberOfBalls = 5;

  Future<void> initializeWorld() async {
    world = World.withGravity(Vector2(0, -10));
    wall = DummyBody(this);

    // add(wall);
    initializeBalls();
    impulsTrigger = Timer(Duration(seconds: 3), () {
      pushBalls(2);
    });
    world.setContactListener(this);
    await Flame.audio.load("billiard-tick.wav");
  }

  void initializeBalls() {
    print(
        "initializeWorld viewport: ${viewport.width} ${viewport.height} ${window.devicePixelRatio} ");

    balls = [];
    ankerPoints = [];
    double x = 0 - (numberOfBalls / 2) * distanceBetweenBalls;
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var ballPosition = Vector2(x, -viewport.height / 2 + 4);
      var ball = BallComponent(this, ballPosition);
      add(ball);
      balls.add(ball);
      ankerPoints.add(Vector2(x, viewport.height / 2 - 2));
      var djd = DistanceJointDef();
      //djd.frequencyHz = 10.0;
      djd.dampingRatio = 1.0;
      djd.initialize(wall.body, balls[ix].body, ankerPoints[ix], ballPosition);
      world.createJoint(djd);
      x += distanceBetweenBalls;
    }
  }

  void pushBalls(int count) {
    for (var nn = 0; nn < count; nn++) {
      balls[nn].impulse(Offset(-0.2, 0.0));
    }
  }

  @override
  void render(canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, viewport.width * viewport.scale,
        viewport.height * viewport.scale);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff33aa33);
    canvas.drawRect(bgRect, bgPaint);

    Rect barRect = Rect.fromLTRB(
        worldVector2ToScreenOffset(ankerPoints[0]).dx - 20,
        20,
        worldVector2ToScreenOffset(ankerPoints[4]).dx + 20,
        40);
    Paint barPaint = Paint();
    barPaint.color = Color(0xff888888);
    canvas.drawRect(barRect, barPaint);

    Paint linePaint = Paint();
    linePaint.color = Color(0xff888888);
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var p1 = worldVector2ToScreenOffset(ankerPoints[ix]);
      var p2 = worldVector2ToScreenOffset(balls[ix].body.position);
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

  @override
  void beginContact(Contact contact) async {
    var ballA = contact.fixtureA.userData as BallComponent;
    var ballB = contact.fixtureB.userData as BallComponent;
//    print("beginContact");
    var vA = ballA.body.linearVelocity;
    var vB = ballB.body.linearVelocity;
    var vDiff = vA - vB;
    if (vDiff.length2 > 3) {
      var volume = min(vDiff.length2 / 40, 1.0);
      //print("${vA.length2} ${vB.length2} ${vDiff.length2} $volume");
      Flame.audio.play("billiard-tick.wav", volume: volume);
    }
  }

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}
