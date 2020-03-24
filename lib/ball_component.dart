import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'utils.dart';

enum PersonType { infected, insane, sane }

class PersonComponent extends BodyComponent {
  static const num PERSON_RADIUS = 1.0;
  static int personCount = 0;

  ImagesLoader images = ImagesLoader();
  Random random = Random();
  int id;
  Timer impulsTrigger;
  PersonType personType;
  Offset previousImpulse;

  PersonComponent(box2d, Vector2 position,
      [Offset initialImpulse, PersonType type = PersonType.insane])
      : super(box2d) {
    id = personCount++;
    personType = type;
    //print("initialImpulse $initialImpulse");
    this.previousImpulse = initialImpulse;
    _loadImages();
    _createBody(position);
    if (this.previousImpulse != null) {
      impulse(this.previousImpulse);
    }
    // if (personType == PersonType.sane && initialImpulse != null) {
    //   impulsTrigger = Timer(Duration(seconds: 40), () {
    //     stop();
    //     impulse(-previousImpulse);
    //   });
    // }
    if (random.nextInt(100) < 5) {
      impulsTrigger =
          Timer.periodic(Duration(seconds: random.nextInt(20) + 10), (_) {
        impulse(Offset(random.nextDouble() * 0.03, random.nextDouble() * 0.03));
      });
    }
  }

  void _loadImages() {
    images.load("neutral", "icons8-neutral.png");
    images.load("sad", "icons8-sad.png");
    images.load("good", "icons8-neutral-yellow.png");
  }

  @override
  void update(double t) {}

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }
    String imageName;
    switch (personType) {
      case PersonType.infected:
        imageName = "sad";
        break;
      case PersonType.insane:
        imageName = "neutral";
        break;
      case PersonType.sane:
        imageName = "good";
        break;
    }
    var image = images.get(imageName);
    paintImage(
        canvas: canvas,
        image: image,
        rect: Rect.fromCircle(center: center, radius: radius),
        flipHorizontally: false,
        fit: BoxFit.contain);
  }

  void _createBody(Vector2 position) {
    final shape = CircleShape();
    shape.radius = PersonComponent.PERSON_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.99;
    activeFixtureDef.friction = 0.01;
    activeFixtureDef.userData = this;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = BodyDef();
    activeBodyDef.linearVelocity = Vector2(0.0, 0.0);
    activeBodyDef.position = position;
    activeBodyDef.type = BodyType.DYNAMIC;
    //activeBodyDef.bullet = true;
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
    previousImpulse = velocity;
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
