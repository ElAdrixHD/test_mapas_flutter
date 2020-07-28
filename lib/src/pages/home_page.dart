import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_sqlite/src/bloc/scan_bloc.dart';
import 'package:qr_sqlite/src/models/scans_model.dart';
import 'package:qr_sqlite/src/pages/direcciones_page.dart';
import 'package:qr_sqlite/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_sqlite/utils/scan_utils.dart' as scanUtil;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QRScanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scansBloc.borrarScansTodos(),
          )
        ],
      ),
      body: _callPage(_currentIndex),
      bottomNavigationBar: _crearBottomNav(),
      floatingActionButton: _crearFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _crearBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Mapa")
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5),
            title: Text("Direcciones")
        ),
      ],
      onTap: (int id){
        setState(() {
          _currentIndex = id;
        });
      },
    );
  }

  Widget _callPage(int pagActual) {
    switch(pagActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }

  Widget _crearFab() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () async {
        //https:/adrianmmudarra.es
        //geo:40.71174275262298,-73.7793482824219
        ScanResult futureString;
        //dynamic futureString = "geo:40.71174275262298,-73.7793482824219";

        try {
          futureString = await BarcodeScanner.scan();
        }catch(e){
          futureString=null;
        }
        print("Mensaje: ${futureString.rawContent}");

        if(futureString != null){
          final scan = ScanModel(valor: futureString.rawContent);
          scansBloc.agregarScan(scan);

          if(Platform.isIOS){
            Future.delayed(Duration(milliseconds: 750), () {
              scanUtil.abrirScan(context,scan);
            });
          }else{
            scanUtil.abrirScan(context, scan);
          }
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
