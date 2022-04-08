// ignore_for_file: file_names

import 'package:gps_routes/DB/database.dart';
import 'package:gps_routes/models/local_entity.dart';

class LocalController {
  final db = DatabaseHandler();

  Future<void> salvarLocal(LocalEntity local) async {
    await db.insertLocal(local);
  }

  Future<void> deletarLocal(int id) async {
    await db.deleteLocal(id);
  }

  Future<List<LocalEntity>> listarLocais() async {
    return await db.listarLocais();
  }

  Future<List<LocalEntity>> buscarLocaisPorRota(int idRota) async {
    return await db.buscarLocaisPorRota(idRota);
  }
}
