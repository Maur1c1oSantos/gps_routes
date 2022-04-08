import 'dart:async';

import 'package:gps_routes/Controllers/local_controller.dart';
import 'package:gps_routes/Controllers/rota_controller.dart';
import 'package:gps_routes/models/local_entity.dart';
import 'package:gps_routes/models/rota_entity.dart';
import 'package:gps_routes/views/Components/default_app_bar.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Historico extends StatefulWidget {
  const Historico({Key? key}) : super(key: key);
  static String routeName = "/historico";

  @override
  State<Historico> createState() => _BodyState();
}

class _BodyState extends State<Historico> {
  final _streamController = StreamController<List<RotaEntity>>();
  RotaController rotaController = RotaController();
  LocalController localController = LocalController();
  late List<LocalEntity> locais;
  _BodyState();

  @override
  void initState() {
    super.initState();
    _carregaRotas();
  }

  _carregaRotas() async {
    List<RotaEntity> _listaRotas = [];
    rotaController.listarRotas().then((value) {
      if (value != null) value.forEach((rota) => _listaRotas.add(rota));
    });
    _streamController.add(_listaRotas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: SizedBox(
        height: 80.h,
        child: StreamBuilder<List<RotaEntity>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Erro ao acessar os dados"));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<RotaEntity> rotas = snapshot.data!;
              return _listView(rotas);
            }),
      ),
    );
  }

  Widget _listView(List<RotaEntity> rotas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: rotas != null ? rotas.length : 0,
        itemBuilder: (context, index) {
          RotaEntity rota = rotas[index];
          return ExpansionTileCard(
            leading: const CircleAvatar(child: Text('A')),
            title: Text(rota.titulo),
            subtitle: Text(
              rota.tempo,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            children: <Widget>[
              const Divider(
                thickness: 5.0,
                height: 1.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.yellow,
                        onPressed: () {},
                      )),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        rotaController.deletarRota(rota.id!);
                      },
                    ),
                  ),
                ],
              ),

              //      child: FutureBuilder<List<LocalEntity>>(
              //       future:
              //           (localController.buscarLocaisPorRota(idRota)),
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {}
              //       }),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "FlutterDevs é especializada na criação de aplicativos ",
                  ),
                ),
              ),
            ],
          );

          // Card(
          //   clipBehavior: Clip.antiAlias,
          //   child: Column(
          //     children: [
          //       ListTile(
          //         // leading: const Icon(Icons.arrow_drop_down_circle),
          //         title: Text(snapshot.data![index].titulo),
          //         subtitle: Text(
          //           snapshot.data![index].tempo,
          //           style:
          //               TextStyle(color: Colors.black.withOpacity(0.6)),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: const ListTile(),
          //       ),
          //       ButtonBar(
          //         alignment: MainAxisAlignment.start,
          //         children: [
          //           IconButton(
          //             icon: const Icon(Icons.edit),
          //             color: Colors.yellow,
          //             onPressed: () {},
          //           ),
          //           IconButton(
          //             icon: const Icon(Icons.delete),
          //             color: Colors.red,
          //             onPressed: () {},
          //           )
          //         ],
          //       ),
          //       // Image.asset('assets/images/dog.jpg'),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}
