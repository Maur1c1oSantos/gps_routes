// ignore_for_file: file_names, library_prefixes, avoid_print, non_constant_identifier_names, no_logic_in_create_state, unnecessary_null_comparison

import 'dart:async';
import 'package:gps_routes/Controllers/local_controller.dart';
import 'package:gps_routes/Controllers/rota_controller.dart';
import 'package:gps_routes/models/local_entity.dart';
import 'package:gps_routes/models/rota_entity.dart';
import 'package:gps_routes/Views/Components/default_app_bar.dart';
import 'package:gps_routes/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  State<Home> createState() => _BodyState();
}

class _BodyState extends State<Home> {
  late LocationData _userLocation;
  late Location _location;
  String street = "";
  late RotaEntity rota;
  RotaController rotaController = RotaController();
  late LocalEntity local;
  LocalController localController = LocalController();
  late GoogleMapController _googleMapController;
  LatLng _local = const LatLng(0.0, 0.0);
  late bool click;
  String tempo = "";
  late final stopwatch = Stopwatch();

  _BodyState();

  @override
  void initState() {
    super.initState();
    click = false;
    _getUserLocation();
  }

  @override
  void dispose() async {
    super.dispose();
    _googleMapController.dispose();
  }

  Future<void> _verificaPermissoes() async {
    _location = Location();

    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getUserLocation() async {
    _verificaPermissoes();
    Location location = Location();
    _userLocation = await location.getLocation();
    _local = LatLng(_userLocation.latitude!, _userLocation.longitude!);
    Future<List<Geocoding.Placemark>> places;

    setState(
      () {
        places = Geocoding.placemarkFromCoordinates(
            _userLocation.latitude!, _userLocation.longitude!,
            localeIdentifier: "pt_BR");
        places.then(
          (value) {
            Geocoding.Placemark place = value[0];
            _local = LatLng(_userLocation.latitude!, _userLocation.longitude!);
            street = place.street!;
          },
        );
      },
    );
  }

  _watchStart() {
    stopwatch.start();
  }

  _watchStop() {
    stopwatch.stop();
  }

  _watchReset() {
    stopwatch.reset();
  }

  _finalizaRota() async {
    _watchStop();
    tempo = stopwatch.elapsed.toString().substring(0, 8);
    rotaController.atualizarRota(tempo);
    _watchReset();
    print("Rota atualizada");
  }

  _novaRota() {
    _watchStart();
    DateTime newDate = DateTime.now();
    String date = newDate.toString().substring(0, 10);
    rota = RotaEntity(titulo: date, tempo: tempo);
    rotaController.salvarRota(rota);
    print("Rota criada");
  }

  _novoLocal() async {
    rota = await rotaController.buscarUltimaRota();
    int idRota = rota.id!;
    local = LocalEntity(
        latitude: _userLocation.latitude!.toString(),
        longitude: _userLocation.longitude!.toString(),
        idRota: idRota);
    localController.salvarLocal(local);
    print("Local criado");
  }

  _ButtomClick() {
    click == false ? click = true : click = false;
    if (click == true) {
      _novaRota();
      _novoLocal();
    }
    _novaPosicao();
  }

  _novaPosicao() {
    if (click == true) {
      Timer(
        const Duration(seconds: 15),
        () => [_getUserLocation(), _novoLocal(), _novaPosicao()],
      );
    } else {
      _finalizaRota();
    }
  }

  void _createdMap(GoogleMapController controller) {
    _googleMapController = controller;
    _location.onLocationChanged.listen((event) {
      _local = LatLng(event.latitude!, event.longitude!);
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _local,
            zoom: 18.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 80.h,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 1.h,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 61.h,
                        child: Card(
                          color: kPrimaryLightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.h),
                            side: BorderSide(
                              color: kPrimaryLightColor,
                              width: 0.5.w,
                            ),
                          ),
                          child: InkWell(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 55.h,
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _local,
                                    ),
                                    mapType: MapType.normal,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    onMapCreated: (controller) =>
                                        _createdMap(controller),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(street,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            splashColor: kPrimaryColor.withAlpha(30),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(5.h),
                              primary: click == false
                                  ? const Color.fromRGBO(69, 165, 39, 1)
                                  : const Color.fromRGBO(194, 42, 42, 1),
                              onPrimary: Colors.red,
                            ),
                            onPressed: () => [
                              _getUserLocation(),
                              _ButtomClick(),
                            ],
                            child: click == false
                                ? const Text(
                                    'Iniciar',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Parar',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
