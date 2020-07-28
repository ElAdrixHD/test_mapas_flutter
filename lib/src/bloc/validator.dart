import 'dart:async';

import 'package:qr_sqlite/src/models/scans_model.dart';

class Validators{
  final validarGeo = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      sink.add(scans.where((element) => element.tipo == "geo").toList());
    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
      handleData: (scans, sink){
        sink.add(scans.where((element) => element.tipo == "http").toList());
      }
  );
}