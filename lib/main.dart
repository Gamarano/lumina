import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // inicializações (ex: SharedPreferences/Hive) daqui a pouco
  runApp(const App());
}
