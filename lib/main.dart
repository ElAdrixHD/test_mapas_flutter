import 'package:flutter/material.dart';
import 'package:qr_sqlite/src/pages/despliegue_mapa_page.dart';
import 'package:qr_sqlite/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QRScanner",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/" : (BuildContext context) => HomePage(),
        "/map" : (BuildContext context) => MapaPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepOrange),
    );
  }
}