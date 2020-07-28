import 'dart:async';

import 'package:qr_sqlite/src/bloc/validator.dart';
import 'package:qr_sqlite/src/providers/db_provider.dart';

class ScansBloc with Validators{

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //obetener scans de la bd
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>>get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>>get scansStreamHTTP => _scansController.stream.transform(validarHttp);

  void dispose(){
    _scansController?.close();
  }

  obtenerScans() async{
    _scansController.sink.add(await DBProvider.db.getScans());

  }

  agregarScan(ScanModel scanModel) async {
    await DBProvider.db.insertScan(scanModel);
    obtenerScans();
  }

  borrarScans(int id) async{
    await DBProvider.db.deleteScans(id);
    obtenerScans();
  }

  borrarScansTodos() async{
    await DBProvider.db.deleteAllScans();
    obtenerScans();
  }

}