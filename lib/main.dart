import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'newtons_game.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final size = await Flame.util.initialDimensions();
  runApp(NewtonsGame(size).widget);
}
