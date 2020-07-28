import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:qr_sqlite/src/bloc/scan_bloc.dart';
import 'package:qr_sqlite/src/models/scans_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas QR"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _createFAB(),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: scan.getLatLng(), zoom: 10.0,),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  LayerOptions _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/'
            '{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':'pk.eyJ1IjoiYWRyaXNhbjEyMyIsImEiOiJja2Q0ZW5zZGQxb2Y0MnhxdmttamI1YTV1In0.vXd4Fy38eAYMe_eaxufGgw',
          'id': 'mapbox/streets-v11'
        },
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers: [
        Marker(point: scan.getLatLng(), width: 100.0, height: 100.0,
            builder: (context) => Container(
              child: Icon(Icons.location_on, size:45, color: Theme.of(context).primaryColor),
            ) ),
      ]
    );
  }

  Widget _createFAB() {
    return FloatingActionButton(
      onPressed: () {  },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
