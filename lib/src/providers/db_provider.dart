import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_sqlite/src/models/scans_model.dart';
export 'package:qr_sqlite/src/models/scans_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "ScansDB.db");

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){

      },
      onCreate: (Database db, int version) async{
        await db.execute("CREATE TABLE scans("
            " id INTEGER PRIMARY KEY,"
            " tipo TEXT,"
            " valor TEXT"
            ")");
      },
    );
  }

  //Crear registros

  Future<int> insertScanRaw(ScanModel scan) async{
    final db = await database;
    final res = await db.rawInsert("INSERT INTO scans (id, tipo, valor) "
        "VALUES (${scan.id}, '${scan.tipo}', '${scan.valor}')");
    return res;
  }

  Future<int> insertScan(ScanModel scan) async{
    final db = await database;
    final res = await db.insert("scans", scan.toJson());
    return res;
  }

  //SELECT

  Future<ScanModel> getScanById(int id) async{
    final db = await database;
    final res = await db.query("scans", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getScans() async{
    final db = await database;
    final res = await db.query("scans");
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansByType(String type) async{
    final db = await database;
    final res = await db.query("scans", where: "tipo = ?", whereArgs: [type]);
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  //Acttualizar

  Future<int> updateScans(ScanModel scanModel) async{
    final db = await database;
    final res = await db.update("scans", scanModel.toJson(), where: "id = ?", whereArgs: [scanModel.id]);
    return res;
  }

  //Borrar
  Future<int> deleteScans(int id) async{
    final db = await database;
    final res = await db.delete("scans", where: "id = ?", whereArgs: [id]);
    return res;
  }


  Future<int> deleteAllScans() async{
    final db = await database;
    final res = await db.delete("scans");
    return res;
  }
}