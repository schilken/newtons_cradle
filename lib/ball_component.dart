import 'dart:async';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer, Position;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'utils.dart';

class BallComponent extends BodyComponent with Tapable {
  static const num PERSON_RADIUS = 1.0;

  ImagesLoader images = ImagesLoader();
  Timer impulsTrigger;

  BallComponent(box2d, Vector2 position)
      : super(box2d) {
    _loadImages();
    _createBody(position);
  }

  void _loadImages() {
    images.load("neutral", "icons8-neutral.png");
    images.load("ball", "black-ball.png");
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }
    paintImage(
        canvas: canvas,
        image: images.get("ball"),
        rect: Rect.fromCircle(center: center, radius: radius),
        fit: BoxFit.contain);
  }

  // void renderCircle(Canvas canvas, Offset center, double radius) {
  //   canvas.save();
  //   //Move the canvas point 0,0 to the top left edge of our ball
  //   canvas.translate(center.dx, center.dy);
  //   //Simply draw the circle
  //   Paint paint = Paint();
  //   paint.color = Color(0xffaaaaaa);
  //   canvas.drawCircle(Offset(0, 0), radius, paint);
  //   canvas.restore();
  // }

  void _createBody(Vector2 position) {
    final shape = CircleShape();
    shape.radius = BallComponent.PERSON_RADIUS;
    shape.p.x = 0.0;

    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.restitution = 1.0;
    fixtureDef.density = 0.99;
    fixtureDef.friction = 0.01;
    fixtureDef.userData = this;
    
    final bodyDef = BodyDef();
    bodyDef.linearVelocity = Vector2(0.0, 0.0);
    bodyDef.position = position;
    bodyDef.type = BodyType.DYNAMIC;
    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
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
    return "linearVelocity ${body.linearVelocity}";
  }
  
  Rect toRect() {
    var rect = Rect.fromCircle(center: Offset(body.position.x, body.position.y), radius: BallComponent.PERSON_RADIUS);
    return rect; 
  }
}
