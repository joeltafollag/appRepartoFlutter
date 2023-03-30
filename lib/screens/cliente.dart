import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';
import 'package:enermax_reparto/db/db.dart';
import 'package:enermax_reparto/models/manifiestos.dart';
import 'package:enermax_reparto/models/mapStyle.dart';
import 'package:enermax_reparto/screens/home.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../repository/funciones.dart';

class Cliente extends StatefulWidget {
  final manifiestos manifiesto;
  const Cliente ({ Key? key, required this.manifiesto }): super(key: key);

  @override
  ClienteState createState() => ClienteState();
}

class ClienteState extends State<Cliente> {
  late GoogleMapController mapController; //contrller for Google map
  late int id=0;
/*   late SharedPreferences prefs;
 */  final observacionController = TextEditingController();
  File? image;
  late Database _database;
  late AccionRepository _accionRepo;

/*   Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;

      final imageTemp = File(image.path);
      File imageTemp1 = File(image.path);
      Uint8List imagebytes = await imageTemp.readAsBytes();
      String base64Image = base64.encode(imagebytes);
      print(base64Image);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  } */

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return;

      File imageTemp = File(image.path);
      Uint8List imagebytes = await imageTemp.readAsBytes();
      String base64Image = base64.encode(imagebytes);
      print(base64Image);
      setState(() {
        this.image = imageTemp;
        (context as Element).reassemble();
      });
      setState(() {
        this.image = imageTemp;
        (context as Element).reassemble();
      });
      
      CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      autoCloseDuration: Duration(seconds: 2),
      showCancelBtn: false,
      title: 'Imagen cargada correctamente',
      ); 
      
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }

  }
  

@override
  void initState() {
    initVariables();
    super.initState();
  }

  @override
  void dispose() {
    // Limpiar el controlador.
    observacionController.dispose();
    super.dispose();
  }

  initVariables() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getInt('id')!;
    });
    _database = await DatabaseConnection.initiateDataBase();
    _accionRepo = AccionRepository(_database);
  }

  alertTerminar()async{
    terminar();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      autoCloseDuration: Duration(seconds: 2),
      showCancelBtn: false,
      title: 'Cliente terminado'
      );
      
  }

  incidencias(){
    showDialog(
            context: context,
            barrierDismissible: false,
            //context: _scaffoldKey.currentContext,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(left: 25, right: 25),
                title: Center(child: Text("Levantar Incidencia")),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                 
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(labelText: "observacion"),
                          controller: observacionController,
                        ),
                        /* MaterialButton(
                color: Colors.blue,
                child: const Text(
                    "Seleccionar imagen",
                  style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold
                  )
                ),
                onPressed: () {
                  pickImage();
                }
            ),  */
            ElevatedButton.icon(
    onPressed: (){
      pickImageC();
    }, 
    icon: Icon(Icons.photo_camera),  //icon data for elevated button
    label: Text("Tomar una foto"), //label text 
),
           
            /* SizedBox(height: 400,
            width: 400,
            child:  /* image != null ? Image.file(image!): Text("No image selected"), */null ), */
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
                        /* uardarManifiesto(_manifiestos.first, ""); */
                      },
                      child: Text("Siguiente")),
                ],
              );
            });
  }

  terminar() async{
    _accionRepo.updateManifiestoEstado(widget.manifiesto.Id); 
    Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
    
          
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
            title: const Text('Cliente'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(color: Color.fromRGBO(0, 140, 221, 1)),
            ),
            centerTitle: true,
          ),
      body: Column(
        children: [
          Row(
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: GoogleMap(
          //Widget del mapa
          zoomGesturesEnabled: true, //zoom del mapa
          initialCameraPosition: CameraPosition(
            target: LatLng(
                21.146963839869848, -101.70971301771652), //initial position
            zoom: 10,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,

        )
                  
                  )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:15),
            child: Text('Antonio Morales', style: GoogleFonts.sarabun(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 140, 221, 1),)
            ),
            ),
          ),
          Expanded(child: 
          ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Card2(),
          ],
        ),
      ),)
        ],
      ),
      floatingActionButton: SpeedDial(
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            direction: SpeedDialDirection.up,
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
                label: 'QR',
                backgroundColor: Color(0xE3005CA7),
                onTap: () => {},
              ),
              SpeedDialChild(
                child:
                    const Icon(Icons.upload_file_outlined, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                label: 'Incidencia',
                onTap: () => {
                  incidencias()
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.check_circle_outlined, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                label: 'Terminar',
                onTap: () => {
                  alertTerminar(),
                },
              ),
            ]),
    );
  }
}


class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return GestureDetector(
        onTap: (() {
          print("object");
        }
        
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 140, 221, 1),
                        Color.fromRGBO(0, 82, 164, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text("Cliente: Jose", style: TextStyle(color: Colors.white),),
                      trailing: Icon(Icons.sd_storage_sharp,
                      color: Colors.lightGreen),
                    ),
                    Row(
                  children: [
                    
                  ],
                ),
                Row(
                children: [
                  
                ],
                          ),
                  ],
                ),
              )
            ),
          ],
        ),
      ));
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in [1, 2, 3, 4]) 
          buildItem("Manifiesto ${i}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: false,
                  hasIcon: false,
                ),
                header: Container(
                  color: Color.fromRGBO(0, 140, 221, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Manifiestos",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Mapa extends State<Cliente>{

  late GoogleMapController mapController; //contrller for Google map
  @override
  Widget build(BuildContext context) {

    return GoogleMap(
          //Widget del mapa
          zoomGesturesEnabled: true, //zoom del mapa
          initialCameraPosition: CameraPosition(
            target: LatLng(
                21.146963839869848, -101.70971301771652), //initial position
            zoom: 10,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          /* markers: getmarkers(), */
          mapType: MapType.normal,
          /* circles: _circles, */
          onMapCreated: (controller) {
            setState(() { 
              mapController = controller;
              mapController.setMapStyle(MapStyle().night);
            }); 
          },
        );
  }
}
