
import 'package:flutter/material.dart';
import 'package:qr_sqlite/src/models/scans_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScan(BuildContext context, ScanModel scanModel) async {
  if(scanModel.tipo == "http"){
    if (await canLaunch(scanModel.valor)) {
      await launch(scanModel.valor);
    } else {
      throw 'Could not launch ${scanModel.valor}';
    }
  }else{
    Navigator.pushNamed(context, "/map", arguments: scanModel);
  }

}