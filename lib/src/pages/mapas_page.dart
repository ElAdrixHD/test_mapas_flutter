import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_sqlite/src/bloc/scan_bloc.dart';
import 'package:qr_sqlite/src/models/scans_model.dart';
import 'package:qr_sqlite/utils/scan_utils.dart' as scanUtil;

class MapasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scansBloc = ScansBloc();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        final scans = snapshot.data;

        if(scans.isEmpty){
          return Center(
            child: Text("No hay información"),
          );
        }
        return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(color: Colors.red,alignment: AlignmentDirectional.centerStart, padding: EdgeInsets.symmetric(horizontal: 20.0), child: Icon(Icons.close, color: Colors.white,),),
              onDismissed: (direction){
                scansBloc.borrarScans(scans[i].id);
              },
              child: ListTile(
                leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
                title: Text(scans[i].valor),
                subtitle: Text("${scans[i].id}"),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onTap: () => scanUtil.abrirScan(context, scans[i]),
        ),
            ));
      },
    );
  }
}
