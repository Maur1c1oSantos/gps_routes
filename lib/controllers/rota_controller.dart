// ignore_for_file: file_names

import 'package:gps_routes/DB/database.dart';
import 'package:gps_routes/models/rota_entity.dart';

class RotaController {
  final db = DatabaseHandler();

  Future<void> salvarRota(RotaEntity rota) async {
    await db.insertRota(rota);
  }

  Future<void> atualizarRota(String tempo) async {
    RotaEntity rota = await db.buscarUltimaRota();
    var editRota = RotaEntity(
      id: rota.id,
      titulo: rota.titulo,
      tempo: tempo,
    );
    await db.updateRota(editRota);
  }

  Future<void> deletarRota(int id) async {
    await db.deleteRota(id);
  }

  Future<List<RotaEntity>> listarRotas() async {
    return await db.listarRotas();
  }

  Future<RotaEntity> buscarUltimaRota() async {
    return await db.buscarUltimaRota();
  }
}
