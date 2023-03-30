import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:enermax_reparto/models/manifiestoDetalle.dart';
import 'package:enermax_reparto/models/manifiestoPickUp.dart';
import 'package:enermax_reparto/models/manifiestos.dart';
import 'package:enermax_reparto/db/db.dart';
import 'package:enermax_reparto/repository/funciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

class Manifiestos extends StatefulWidget {
  const Manifiestos({Key? key}) : super(key: key);

  @override
  _ManifiestosState createState() => _ManifiestosState();
}

class _ManifiestosState extends State<Manifiestos> {
  final grupo1_controller = TextEditingController();
  final grupo2_controller = TextEditingController();
  final grupo3_controller = TextEditingController();
  final grupo4_controller = TextEditingController();
  final grupo5_controller = TextEditingController();
  final grupo6_controller = TextEditingController();
  final grupo7_controller = TextEditingController();
  final motos_controller = TextEditingController();
  late SharedPreferences logindata;
  late String token = "";
  late Database _database;
  late AccionRepository _accionRepo;
  final urlManifiestoPickUp = Uri.parse(
      "https://enersisuat.azurewebsites.net/api/Manifiesto/ManifiestoPickUp");
  late Future<List<manifiestoDetalle>> detallesList;
  late Future<List<manifiestos>> manifiestosList1;
  List<manifiestoDetalle> _manifiestos1 = List.empty();
  Future<List<manifiestos>>? manifiestosList;
  List<manifiestoDetalle> _manifiestosDetalle = List.empty();
  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(80.0, 56.0);

  getManifiestosLocal(int id) async {
    _manifiestos1 = await _accionRepo.getAllManifiestosFetalle(id);
    setState(() {
      _manifiestos1;
    });
    refreshList();
  }

/*   void firma(manifiestos data) async {
     int grupo1 = int.parse(grupo1_controller.text == "" ? "0" : grupo1_controller.text);
     int grupo2 = int.parse(grupo2_controller.text == "" ? "0" : grupo2_controller.text);
     int grupo3 = int.parse(grupo3_controller.text == "" ? "0" : grupo3_controller.text);
     int grupo4 = int.parse(grupo4_controller.text == "" ? "0" : grupo4_controller.text);
     int grupo5 = int.parse(grupo5_controller.text == "" ? "0" : grupo5_controller.text);
     int grupo6 = int.parse(grupo6_controller.text == "" ? "0" : grupo6_controller.text);
     int grupo7 = int.parse(grupo7_controller.text == "" ? "0" : grupo7_controller.text);
     int grupoMotos = int.parse(motos_controller.text == "" ? "0" : motos_controller.text);
     int total = grupo1, grupo2, grupo3, grupo4, grupo5+ grupo6+ grupo7+grupoMotos;
    
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text("Firma")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Grupo 1: ${grupo1}'),
                    Text('Grupo 2: ${grupo2}'),
                    Text('Grupo 3: ${grupo3}'),
                    Text('Grupo 4: ${grupo4}'),
                    Text('Grupo 5: ${grupo5}'),
                    Text('Grupo 6: ${grupo6}'),
                    Text('Grupo 7: ${grupo7}'),
                    Text('Motos: ${grupoMotos}'),
                    Text('Total: ${}'),
                    Signature(
                      controller: controller,
                      height: 400,
                      width: 400,
                      backgroundColor: Colors.black12,
                    )
                  ],
                  
                )),
            actions: [
              TextButton(
                  onPressed: () async {
                    final imageData = await controller
                        .toPngBytes(); // must be called in async method
                    final imageEncoded = base64.encode(imageData!);
                    guardarManifiesto(data, imageEncoded);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    /* SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]); */

                    /* guardarManifiesto(); */
                  },
                  child: Text("Guardar")),
            ],
          );
        });
  } */

  void scanQR() async {
    var qrValue;
    String? cameraScanResult = await scanner.scan();
    setState(() {
      qrValue = cameraScanResult!;
    });
    List<manifiestoDetalle> _manifiestosDetalle = List.empty();
    _manifiestosDetalle = await _accionRepo.getAllManifiestosFetalleQr(qrValue);
    List<manifiestos> _manifiestos = List.empty();
    _manifiestos = await _accionRepo.getManifiestoQr(qrValue);
    if (_manifiestos.length == 0) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "No se encontro el manifiesto!",
              text: ""));
    } else {
      if (_manifiestosDetalle.length != 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            //context: _scaffoldKey.currentContext,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(left: 25, right: 25),
                title: Center(child: Text("Detalles")),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                  height: 550,
                  width: 300,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Serie:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_manifiestos.first.Serie),
                      Text('Generador:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_manifiestos.first.Generador),
                      Text('Domicilio:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_manifiestos.first.Domicilio),
                      Divider(
                        color: Color.fromARGB(255, 0, 0, 0),
                        thickness: 2,
                      ),
                      Container(
                          height: 370,
                          child: ListView.builder(
                            itemCount: _manifiestosDetalle.length,
                            itemBuilder: (context, index) {
                              final item = _manifiestosDetalle[index];
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 120,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, bottom: 5),
                                                  child: Text(
                                                      'Grupo ${item.GrupoId.toString()}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 115,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Text(
                                                      'Cantidad: ${item.Cantidad.toString()}'),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    Divider(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      thickness: 2,
                                    ),
                                  ]));
                            },
                          ))
                    ],
                  )),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Aceptar")),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            //context: _scaffoldKey.currentContext,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(left: 25, right: 25),
                title: Center(child: Text("Cascos")),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                  height: 550,
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Serie:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_manifiestos.first.Serie),
                        Text('Generador:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_manifiestos.first.Generador),
                        Text('Domicilio:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_manifiestos.first.Domicilio),
                        Divider(
                          color: Color.fromARGB(255, 0, 0, 0),
                          thickness: 2,
                        ),
                        TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Grupo 1"),
                            controller: grupo1_controller),
                        TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Grupo 2"),
                            controller: grupo2_controller),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Grupo 3"),
                          controller: grupo3_controller,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Grupo 4"),
                          controller: grupo4_controller,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Grupo 5"),
                          controller: grupo5_controller,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Grupo 6"),
                          controller: grupo6_controller,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Grupo 7"),
                          controller: grupo7_controller,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Motos"),
                          controller: motos_controller,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar",
                          style: TextStyle(color: Colors.red))),
                  TextButton(
                      onPressed: () {
                        /* SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);*/
                        guardarManifiesto(_manifiestos.first, "");
                      },
                      child: Text("Siguiente")),
                ],
              );
            });
      }
    }
  }

  getManifiestos() async {
    logindata = await SharedPreferences.getInstance();
    final urlManifiestos = Uri.parse(
        "https://enersisuat.azurewebsites.net/api/Manifiesto/ManifiestosAcopio?estatus=2&cedisId=${logindata.getInt('cedis')}");
    //Headers
    final headers = {
      HttpHeaders.authorizationHeader: logindata.getString('token')!
    };
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.get(urlManifiestos, headers: headers);
        final lista = List.from(jsonDecode(response.body));
        List<manifiestos> manifiestosList = [];
        if (lista != null) {
          lista.forEach((element) async {
            Map obj = element;
            List ll = obj['Detalles'];
            List<manifiestoDetalle> _manifiestos = List.empty();
            _manifiestos =
                await _accionRepo.getAllManifiestosFetalle(element['Id']);
            setState(() {
              _manifiestos;
              _manifiestos1 = _manifiestos;
            });
            var modelo1 = manifiestos(
                Id: element['Id'],
                Serie: element['Serie'].toString(),
                Generador: element['Generador'],
                Domicilio: element['Domicilio'],
                Hash: element['Hash'].toString(),
                Firma: "",
                Latitud: 0.0,
                Longitud: 0.0,
                estatus: ll.length == 0 ? 0 : 2);
            if (ll.length != 0) {
              if (_manifiestos.length == 0) {
                ll.forEach((element) async {
                  /*  try { */
                  var modelo = manifiestoDetalle(
                      IdManifiesto: modelo1.Id,
                      GrupoId: element['GrupoId'],
                      ArticuloId: element['ArticuloId'],
                      Cantidad: element['Cantidad']);
                  await _accionRepo.insertarManifiestoDetalle(modelo);
                });
              }
            }
            try {
              await _accionRepo.insertarManifiesto(modelo1);
              print(element['Id']);
            } on Exception catch (_) {
              print('manifiesto');
            }
          });
        } else {
          print("Lista vacia");
        }
      }
    } on SocketException catch (_) {
      print('sin conexion');
    }
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    getManifiestos();
    setState(() {
      manifiestosList = _accionRepo.getAllManifiestos();
    });
    return null;
  }

  @override
  void dispose() {
    // Limpiar el controlador.
    grupo1_controller.dispose();
    grupo2_controller.dispose();
    grupo3_controller.dispose();
    grupo4_controller.dispose();
    grupo5_controller.dispose();
    grupo6_controller.dispose();
    grupo7_controller.dispose();
    motos_controller.dispose();
    super.dispose();
  }

  guardarManifiesto(manifiestos data, String Firma) async {
    /* final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: logindata.getString('token')!
    }; */
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String grupo1 = grupo1_controller.text;
    String grupo2 = grupo2_controller.text;
    String grupo3 = grupo3_controller.text;
    String grupo4 = grupo4_controller.text;
    String grupo5 = grupo5_controller.text;
    String grupo6 = grupo6_controller.text;
    String grupo7 = grupo7_controller.text;
    String motos = motos_controller.text;
    /* final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token
    }; */
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      List<ManifiestoPickUp> _manifiestosPickUp = List.empty();
      List<DetallesPickUp> _DetallePickUp = [];
      if (grupo1 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 1,
            ArticuloId: 1,
            Cantidad: int.parse(grupo1.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo2 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 2,
            ArticuloId: 2,
            Cantidad: int.parse(grupo2.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo3 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 3,
            ArticuloId: 3,
            Cantidad: int.parse(grupo3.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo4 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 4,
            ArticuloId: 4,
            Cantidad: int.parse(grupo4.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo5 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 5,
            ArticuloId: 5,
            Cantidad: int.parse(grupo5.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo6 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 6,
            ArticuloId: 6,
            Cantidad: int.parse(grupo6.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (grupo7 != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 7,
            ArticuloId: 7,
            Cantidad: int.parse(grupo7.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      if (motos != "") {
        var modelo = manifiestoDetalle(
            IdManifiesto: data.Id,
            GrupoId: 8,
            ArticuloId: 8,
            Cantidad: int.parse(motos.toString()));
        await _accionRepo.insertarManifiestoDetalle(modelo);
      }
      refreshList();

      var modelo1 = manifiestos(
          Id: data.Id,
          Serie: data.Serie,
          Generador: data.Generador,
          Domicilio: data.Domicilio,
          Hash: data.Hash,
          Firma: Firma,
          Latitud: position.latitude,
          Longitud: position.longitude,
          estatus: 1);
      _accionRepo.updateManifiesto(modelo1);
      /* var json = jsonEncode(_DetallePickUp.map((e) => e.toJsonAttr()).toList()); */
      /* final String detalle = jsonEncode(_DetallePickUp) */
      /* String ss = json;
      final manifiestoPick = {
        "Id": id,
        "Firma": Firma,
        "Latitud": 232,
        "Longitud": 2323,
        "Detalles": []
      };
      final String jsonString = jsonEncode(manifiestoPick);
      var ll = jsonString.replaceAll("[]", "$ss");
      print(ll);
      var response =
          await http.put(urlManifiestoPickUp, headers: headers, body: ll); */
      // ignore_for_file: unnecessary_string_escapes
      // ignore: unused_local_variable
      /* final snackBar = SnackBar(
          content: Text('El manifiesto se envio correctamente!'),
          backgroundColor: Colors.green);
      final snackBarError = SnackBar(
          content: Text('Error al enviar el manifiesto!'),
          backgroundColor: Colors.red);
 */
// Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!

      /*  if (response.statusCode == 200) {
        _accionRepo.updateManifiesto(id);
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Scaffold.of(context).showSnackBar(snackBarError);
      } */
      /* refreshList(); */
      /* if (response.statusCode == 200) {
                _accionRepo.deleteCheck(element.id);
                _accionRepo.updateCheck(element.id);
              } */
      setState(() {
        grupo1_controller.clear();
        grupo2_controller.clear();
        grupo3_controller.clear();
        grupo4_controller.clear();
        grupo5_controller.clear();
        grupo6_controller.clear();
        grupo7_controller.clear();
        motos_controller.clear();
        controller.clear();
      });
    }
    /* final snackBar = SnackBar(
        content: const Text('Ruta terminada exitosamente!'),
        backgroundColor: Colors.blue,
        elevation: 10,
        duration: new Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar); */

    /* mostrarCheck(); */
  }

  terminarRuta() async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: logindata.getString('token')!
    };
    List<manifiestos> manifiestosList;
    manifiestosList = await _accionRepo.getAllManifiestos();
    List<manifiestoDetalle> _manifiestosDetalle = List.empty();

    manifiestosList.forEach((element) async {
      if (element.estatus == 1) {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _manifiestosDetalle =
              await _accionRepo.getAllManifiestosFetalle(element.Id);
          var json = jsonEncode(
              _manifiestosDetalle.map((e) => e.toJsonAttr()).toList());
          /* final String detalle = jsonEncode(_DetallePickUp) */
          String ss = json;
          final manifiestoPick = {
            "Id": element.Id,
            "Firma": element.Firma,
            "Latitud": element.Latitud,
            "Longitud": element.Longitud,
            "Detalles": []
          };
          final String jsonString = jsonEncode(manifiestoPick);
          var ll = jsonString.replaceAll("[]", "$ss");
          print(ll);
          var response =
              await http.put(urlManifiestoPickUp, headers: headers, body: ll);

          final snackBar = SnackBar(
              content: Text(
                  'El manifiesto ${element.Serie} se envio correctamente!'),
              backgroundColor: Colors.green);
          final snackBarError = SnackBar(
              content: Text('Error al enviar el manifiesto  ${element.Serie}!'),
              backgroundColor: Colors.red);
          if (response.statusCode == 200) {
            _accionRepo.updateManifiestoEstado(element.Id);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBarError);
          }
          refreshList();
        }
      }
    });
  }

  initVariables() async {
    _database = await DatabaseConnection.initiateDataBase();
    _accionRepo = AccionRepository(_database);
    manifiestosList = _accionRepo.getAllManifiestos();
    setState(() {
      manifiestosList;
    });
  }

  String qrValue = "Código QR";
  Future<void> _launchURL(String url) async {
    //Para lanzar la aplicación en la screen correspondiente
    //debo mandar la url//
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw 'No se pudo lanzar la url';
    }
  }

  @override
  void initState() {
    initVariables();
    getManifiestos();
    super.initState();
    setState(() {
      manifiestosList;
    });
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LTH Scanner',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: FutureBuilder<List<manifiestos>>(
            future: manifiestosList,
            builder: (context, snap) {
              if (snap.hasData) {
                return manifiestosList != null
                    ? RefreshIndicator(
                        key: refreshKey,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(),
                            itemCount: snap.data!.length,
                            itemBuilder: (context, index) {
                              /* return Slidable(child: null,) */
                              return GestureDetector(
                                  onTap: () async {
                                    List<manifiestoDetalle>
                                        _manifiestosDetalle = List.empty();
                                    _manifiestosDetalle = await _accionRepo
                                        .getAllManifiestosFetalle(
                                            snap.data![index].Id);
                                    setState(() {
                                      if (_manifiestosDetalle.length == 0) {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            //context: _scaffoldKey.currentContext,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.only(
                                                    left: 25, right: 25),
                                                title: Center(
                                                    child: Text("Cascos")),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                content: Container(
                                                  height: 550,
                                                  width: 300,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: <Widget>[
                                                        Text('Serie:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(snap.data![index]
                                                            .Serie),
                                                        Text('Generador:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(snap.data![index]
                                                            .Generador),
                                                        Text('Domicilio:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(snap.data![index]
                                                            .Domicilio),
                                                        Divider(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          thickness: 2,
                                                        ),
                                                        TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        "Grupo 1"),
                                                            controller:
                                                                grupo1_controller),
                                                        TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        "Grupo 2"),
                                                            controller:
                                                                grupo2_controller),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Grupo 3"),
                                                          controller:
                                                              grupo3_controller,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Grupo 4"),
                                                          controller:
                                                              grupo4_controller,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Grupo 5"),
                                                          controller:
                                                              grupo5_controller,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Grupo 6"),
                                                          controller:
                                                              grupo6_controller,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Grupo 7"),
                                                          controller:
                                                              grupo7_controller,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Motos"),
                                                          controller:
                                                              motos_controller,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancelar",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))),
                                                  TextButton(
                                                      onPressed: () {
                                                        /* SystemChrome
                                                            .setPreferredOrientations([
                                                          DeviceOrientation
                                                              .landscapeLeft
                                                        ]); */
                                                        guardarManifiesto(
                                                            snap.data![index],
                                                            "");
                                                      },
                                                      child: Text("Siguiente")),
                                                ],
                                              );
                                            });
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            //context: _scaffoldKey.currentContext,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.only(
                                                    left: 25, right: 25),
                                                title: Center(
                                                    child: Text("Detalles")),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                content: Container(
                                                  height: 550,
                                                  width: 300,
                                                  child: SingleChildScrollView(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Row(
                                                        children: [Column()],
                                                      ),
                                                      Text('Serie:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(snap
                                                          .data![index].Serie),
                                                      Text('Generador:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(snap.data![index]
                                                          .Generador),
                                                      Text('Domicilio:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(snap.data![index]
                                                          .Domicilio),
                                                      Divider(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        thickness: 2,
                                                      ),
                                                      Container(
                                                          height: 370,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _manifiestosDetalle
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final item =
                                                                  _manifiestosDetalle[
                                                                      index];
                                                              return Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 120,
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                                                                                      child: item.GrupoId == 8 ? Text('Motos', style: TextStyle(fontWeight: FontWeight.bold)) : Text('Grupo ${item.GrupoId.toString()}', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 115,
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                                                                                      child: Text('Cantidad: ${item.Cantidad.toString()}'),
                                                                                    )
                                                                                  ],
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Divider(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          thickness:
                                                                              2,
                                                                        ),
                                                                      ]));
                                                            },
                                                          ))
                                                    ],
                                                  )),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Aceptar")),
                                                ],
                                              );
                                            });
                                      }
                                    });
                                  },
                                  child: Slidable(
                                      startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: null,
                                              backgroundColor:
                                                  Color(0xFF21B7CA),
                                              foregroundColor: Colors.white,
                                              icon: Icons.timer,
                                              label: 'Iniciar',
                                            ),
                                          ]),
                                      endActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          children: [
                                            SlidableAction(
                                              flex: 1,
                                              onPressed: null,
                                              backgroundColor:
                                                  Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.timer_off_sharp,
                                              label: 'Terminar',
                                            ),
                                          ]),
                                      child: Container(
                                        width: 500,
                                        child: Card(
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                          /* shadowColor: Color.fromARGB(115, 119, 115, 115), */
                                          child: ListTile(
                                            leading: SizedBox(
                                                height: 60.0,
                                                width:
                                                    60.0, // fixed width and height
                                                child: Row(children: [
                                                  if (snap.data![index]
                                                          .estatus ==
                                                      0) ...[
                                                    Image.asset(
                                                      "assets/addManifest.png",
                                                      width: 60,
                                                      height: 60,
                                                    )
                                                  ] else if (snap.data![index]
                                                          .estatus ==
                                                      1) ...[
                                                    Image.asset(
                                                        "assets/manifest.png",
                                                        width: 60,
                                                        height: 60)
                                                  ] else if (snap.data![index]
                                                          .estatus ==
                                                      2) ...[
                                                    Image.asset(
                                                        "assets/uploadManifest.png",
                                                        width: 60,
                                                        height: 60)
                                                  ]
                                                ])
                                                /* snap.data![index].estatus ==
                                                    0
                                                ? Image.asset(
                                                    "assets/addManifest.png")
                                                : Image.asset(
                                                    "assets/manifest.png") */
                                                ),
                                            title: Text(
                                                'Serie:\n${snap.data![index].Serie}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 17)),
                                            subtitle: Text(
                                              'Generador:\n${snap.data![index].Generador}\nDomicilio:\n${snap.data![index].Domicilio}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            trailing: null,
                                            isThreeLine: true,
                                          ),
                                        ),
                                        height: 200,
                                        /* width: 150, */
                                        color:
                                            Color.fromARGB(255, 234, 227, 227),
                                      )));
                            }),
                        onRefresh: refreshList,
                      )
                    : Center(child: CircularProgressIndicator());

                if (snap.hasError) {
                  return const Center(
                    child: Text("error"),
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: SpeedDial(
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            spacing: 3,
            childrenButtonSize: Size(60, 60),
            animatedIcon: AnimatedIcons.menu_arrow,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            activeBackgroundColor: Color(0xE3005CA7),
            backgroundColor: Color(0xE3005CA7),
            animationCurve: Curves.elasticInOut,
            buttonSize: Size(56, 56),
            children: [
              SpeedDialChild(
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                backgroundColor: Color(0xE3005CA7),
                onTap: () => scanQR(),
              ),
              SpeedDialChild(
                child:
                    const Icon(Icons.upload_file_outlined, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                onTap: () => terminarRuta(),
              ),
              SpeedDialChild(
                child: const Icon(Icons.sync, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                onTap: () => refreshList(),
              ),
            ]),
      ),
    );
  }
}
