import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'utils.dart';

class BallComponent extends BodyComponent {
  static const num PERSON_RADIUS = 1.0;
  static int ballCount = 0;

  ImagesLoader images = ImagesLoader();
  Random random = Random();
  int id;
  Timer impulsTrigger;

  BallComponent(box2d, Vector2 position)
      : super(box2d) {
    id = ballCount++;
    //print("initialImpulse $initialImpulse");
    _loadImages();
    _createBody(position);
  }

  void _loadImages() {
    images.load("neutral", "icons8-neutral.png");
  }

  @override
  void update(double t) {}

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }
    var image = images.get("neutral");
    paintImage(
        canvas: canvas,
        image: image,
        rect: Rect.fromCircle(center: center, radius: radius),
        flipHorizontally: false,
        fit: BoxFit.contain);
  }

  void _createBody(Vector2 position) {
    final shape = CircleShape();
    shape.radius = BallComponent.PERSON_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 1.0;
    activeFixtureDef.density = 0.99;
    activeFixtureDef.friction = 0.01;
    activeFixtureDef.userData = this;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = BodyDef();
    activeBodyDef.linearVelocity = Vector2(0.0, 0.0);
    activeBodyDef.position = position;
    activeBodyDef.type = BodyType.DYNAMIC;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    impulse(Offset(details.delta.dx, -details.delta.dy) * 0.0005);
  }

  void handleDragEnd(DragEndDetails details) {
//    impulse(Offset(details.velocity.pixelsPerSecond.dx, -details.velocity.pixelsPerSecond.dy) * 0.0005);
  }

  void impulse(Offset velocity) {
    //print("impulse on person $id ${velocity.dx}/${velocity.dy}}");
    Vector2 force = Vector2(velocity.dx, velocity.dy)..scale(100.0);
    body.applyLinearImpulse(force, center, true);
  }

  void stop() {
    body.linearVelocity = Vector2(0.0, 0.0);
    body.angularVelocity = 0.0;
  }

  void setVelocity(Vector2 direction, double speed) {
    body.linearVelocity = direction;
    body.angularVelocity = speed;
  }

  @override
  String toString() {
    return "linearVelocity ${body.linearVelocity} angularVelocity: ${body.angularVelocity}";
  }
}
