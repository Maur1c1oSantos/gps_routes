// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

// import 'dart:math';

import 'package:gps_routes/Views/Components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gps_routes/models/local_entity.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Rota_Map extends StatefulWidget {
  const Rota_Map({Key? key, required this.locais}) : super(key: key);
  static String routeName = "/mapa";
  final List<LocalEntity> locais;

  @override
  State<Rota_Map> createState() => _BodyMapState();
}

class _BodyMapState extends State<Rota_Map> {
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late List<LocalEntity> locais = [];
  late String localInicio = '';
  late String localDestino = '';
  // late String distanciaTotal = '';
  List<PolylineWayPoint> wayPoints = [];
  late PointLatLng inicio;
  late PointLatLng destino;

  var inicioEFimDeRota = {
    "latInicio": '',
    "lngInicio": '',
    "latDestino": '',
    "lngDestino": '',
  };

  @override
  void initState() {
    super.initState();
    locais = widget.locais;
    var localInicial = locais[0];
    var localFinal = locais[locais.length - 1];
    inicioEFimDeRota = {
      "latInicio": localInicial.latitude.toString(),
      "lngInicio": localInicial.longitude.toString(),
      "latDestino": localFinal.latitude.toString(),
      "lngDestino": localFinal.longitude.toString(),
    };
    _setWayPoints();
    _addMarker(
        LatLng(double.parse(localInicial.latitude),
            double.parse(localInicial.longitude)),
        "origin",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _addMarker(
        LatLng(double.parse(localFinal.latitude),
            double.parse(localFinal.longitude)),
        "destination",
        BitmapDescriptor.defaultMarker);
    _getPolyline();
  }

  _setWayPoints() {
    inicio = PointLatLng(double.parse(inicioEFimDeRota['latInicio']!),
        double.parse(inicioEFimDeRota['lngInicio']!));
    destino = PointLatLng(double.parse(inicioEFimDeRota['latDestino']!),
        double.parse(inicioEFimDeRota['lngDestino']!));
    for (var i = 0; i < locais.length; i++) {
      if (i > 0 && i < locais.length - 1) {
        wayPoints.add(PolylineWayPoint(
            location: locais[i].latitude + ',' + locais[i].longitude));
      }
    }
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyA3YpZlnhYYGSNG7E0WIDLTL-3sEST4qi4', inicio, destino,
        wayPoints: wayPoints, travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    // double distancia = 0.0;
    // for (var i = 0; i < polylineCoordinates.length - 1; i++) {
    //   distancia += calculaDistancia(
    //       polylineCoordinates[i].latitude,
    //       polylineCoordinates[i].longitude,
    //       polylineCoordinates[i + 1].latitude,
    //       polylineCoordinates[i + 1].longitude);
    // }
    // distanciaTotal = distancia.toStringAsFixed(2);
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  // double calculaDistancia(lat1, lon1, lat2, lon2) {
  //   var p = 0.017453292519943295;
  //   var a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: SizedBox(
              height: 89.1.h,
              // width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(inicioEFimDeRota['latInicio']!),
                      double.parse(inicioEFimDeRota['lngInicio']!),
                    ),
                    zoom: 15),
                myLocationEnabled: false,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
