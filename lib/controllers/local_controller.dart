// ignore_for_file: file_names

import 'package:gps_routes/DB/database.dart';
import 'package:gps_routes/models/local_entity.dart';

class LocalController {
  final db = DatabaseHandler();

  salvarLocal(LocalEntity local) async {
    await db.insertLocal(local);
  }

  deletarLocal(int id) async {
    await db.deleteLocal(id);
  }

  Future<List<LocalEntity>> listarLocaisporRota(int idRota) async {
    return await db.listarLocaisPorRota(idRota);
  }
}
