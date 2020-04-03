import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/material.dart';

class WallBody extends BodyComponent {
  double width;
  double height;
  Offset offset;

  WallBody(
      Box2DComponent box, this.width, this.height, this.offset)
      : super(box) {
    _createBody();
  }

  void _createBody() {
    double x = offset.dx * (box.viewport.width - width)/2;
    double y = (-offset.dy) * (box.viewport.height - height)/2;
    print("WallBody: x/y $x/$y");

    final shape = PolygonShape();
    shape.setAsBoxXY(width/2, height/2);
    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape; 

    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.0;
    final bodyDef = BodyDef();
    bodyDef.position = Vector2(x, y);
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
  }
} 