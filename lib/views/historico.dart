import 'dart:async';

import 'package:gps_routes/Controllers/local_controller.dart';
import 'package:gps_routes/Controllers/rota_controller.dart';
import 'package:gps_routes/models/local_entity.dart';
import 'package:gps_routes/models/rota_entity.dart';
import 'package:gps_routes/views/Components/default_app_bar.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gps_routes/views/rota_map.dart';

class Historico extends StatefulWidget {
  const Historico({Key? key}) : super(key: key);
  static String routeName = "/historico";

  @override
  State<Historico> createState() => _BodyState();
}

class _BodyState extends State<Historico> {
  final _streamRotasController = StreamController<List<RotaEntity>>();
  final _streamLocaisController = StreamController<List<LocalEntity>>();
  RotaController rotaController = RotaController();
  LocalController localController = LocalController();
  _BodyState();

  @override
  void initState() {
    super.initState();
    carregaRotas();
  }

  void carregaRotas() async {
    List<RotaEntity> rotas = await rotaController.listarRotas();
    _streamRotasController.add(rotas);
  }

  void carregaLocais(int idRota) async {
    List<LocalEntity> locais =
        await localController.listarLocaisporRota(idRota);

    _streamLocaisController.add(locais);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: StreamBuilder<List<RotaEntity>>(
        stream: _streamRotasController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<RotaEntity> rotas = snapshot.data!;
          return ListView.builder(
            // shrinkWrap: false,
            scrollDirection: Axis.vertical,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: rotas.length,
            itemBuilder: (context, index) {
              RotaEntity rota = rotas[index];
              return ExpansionTileCard(
                title: Text(rota.titulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  'Tempo: ' + rota.tempo,
                  style: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.6)),
                ),
                children: <Widget>[
                  const Divider(
                    thickness: 5.0,
                    height: 1.0,
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: FutureBuilder<List<LocalEntity>>(
                          future: localController.listarLocaisporRota(rota.id!),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  LocalEntity local = snapshot.data![index];
                                  return Center(
                                    child: ListTile(
                                      title: Text(
                                        local.rua,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: const Icon(Icons.map),
                            color: Colors.yellow,
                            onPressed: () async {
                              var locais = await localController
                                  .listarLocaisporRota(rota.id!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Rota_Map(
                                    locais: locais,
                                  ),
                                ),
                              );
                            },
                          )),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            rotaController.deletarRota(rota.id!);
                            setState(() {
                              carregaRotas();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
