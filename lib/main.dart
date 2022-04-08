import 'package:flutter/material.dart';
import 'package:gps_routes/DB/database.dart';
import 'package:gps_routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseHandler();
  await db.initializeDB();

  runApp(const Routes());
}
