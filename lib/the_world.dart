import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ball_component.dart';
import 'wall_body.dart';

class TheWorld extends Box2DComponent implements ContactListener {
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  static const double scale = 20.0;
  World world;

  List<BallComponent> balls = [];
  WallBody wall;

  Random random = Random();
  Timer impulsTrigger;
  TheWorld() : super(scale: scale, gravity: 0);

  static const distanceBetweenBalls = 2.01;
  static const numberOfBalls = 5;

  void initializeWorld() {
    final Vector2 _gravity = Vector2(0, -10);
    world = World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    world.setContactListener(this);
    print("viewport: ${viewport.width} ${viewport.height}");

    wall =
        WallBody(this, Orientation.landscape, 1.0, 0.05, Alignment.topCenter);
    add(wall);
    // add(WallBody(
    //     this, Orientation.portrait, 1.0, 0.05, Alignment.bottomCenter));
    List<BallComponent> balls = [];
    double x = 0 - (numberOfBalls/2) * distanceBetweenBalls;
    for (var ix = 0; ix < numberOfBalls; ix++) {
      var ball = BallComponent(this, Vector2(x, -viewport.height/2+2), Offset(0.0, 0.0));
      add(ball);
      balls.add(ball);
      var djd = DistanceJointDef();
      djd.frequencyHz = 10.0;
      djd.dampingRatio = 1.0;
      djd.initialize(
          wall.body, balls[ix].body, Vector2(x, viewport.height), Vector2(x, -viewport.height/2+2));
      world.createJoint(djd);
      x += distanceBetweenBalls;
    }
    impulsTrigger = Timer(Duration(seconds: 3), () {
      balls[0].impulse(Offset(-0.2, 0.0));
      balls[1].impulse(Offset(-0.2, 0.0));
      balls[2].impulse(Offset(-0.2, 0.0));
    });

    //DistanceJoint(world.getPool(), djd);
  }

  @override
  void update(t) {
    super.update(t);
    //cameraFollow(person0, horizontal: 0.4, vertical: 1.0);
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

  @override
  void resize(Size size) {
    print("resize: $size");
    super.resize(size);
  }

  void handleTap(Offset position, {bool down}) {
    print("position: $position $down ");
  }

  void handleDragUpdate(DragUpdateDetails details) {
//    ball0.handleDragUpdate(details);
  }

  void handleDragEnd(DragEndDetails details) {
//    ball0.handleDragEnd(details);
  }

  @override
  void beginContact(Contact contact) {
    var fudA = contact.fixtureA.userData as BallComponent;
    var fudB = contact.fixtureB.userData as BallComponent;
    //print("beginContact ${fudA.infected} ${fudB.infected}");
  }

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}
