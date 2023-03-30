import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enermax_reparto/screens/cliente.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Clientes extends StatefulWidget {
  const Clientes({Key? key}) : super(key: key);

  @override
  _ClientesState createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  int _counter = 0;
  final grupo1_controller = TextEditingController();
  final grupo2_controller = TextEditingController();
  final grupo3_controller = TextEditingController();
  final grupo4_controller = TextEditingController();
  final grupo5_controller = TextEditingController();
  final grupo6_controller = TextEditingController();
  final grupo7_controller = TextEditingController();
  final motos_controller = TextEditingController();
  late int id=0;
  /* late SharedPreferences prefs; */
  static late SharedPreferences prefs;
  
 @override
  void initState() {
    initVariables();
    configure();
    super.initState();
  }
  static void configure() async {
    
  }

  initVariables() async{
/*     prefs = await SharedPreferences.getInstance();
 */    
prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', -1);
setState(() {
      id=prefs.getInt('id')!;
      prefs;
    });
  }
  inic(int id)async{
/*     final prefs = await SharedPreferences.getInstance();
    
 */    
/*     int? dd = prefs.getInt('id');
 */  if(prefs.getInt('id') == -1){
      int inicio = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt('id', id);
    prefs.setInt('myTimestampKey', inicio);
    setState(() {
      id=id;
    });
/*     Navigator.push(context,MaterialPageRoute(builder: (context) => Cliente()));
 */    }else{
      QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: '',
      confirmBtnText: 'Aceptar',
      text: 'Ya existe un cliente en proceso',
      );
      print('Error de cliente');
    }
    
    
    
  }

  ter(int id) async{
    /* final prefs = await SharedPreferences.getInstance(); */
    if(prefs.getInt('id') != 0 ){
      if(id == prefs.getInt('id')){
        int? timestamp = prefs.getInt('myTimestampKey');
        DateTime before = DateTime.fromMillisecondsSinceEpoch(timestamp!);
        DateTime now = DateTime.now();
        Duration timeDifference = now.difference(before); 
        prefs.setInt('id', 0);
        print(timeDifference);       
    }else{
      QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: '',
      confirmBtnText: 'Aceptar',
      text: 'Error de cliente',
      );
      print('Esta un cliente en proceso');
    }
    }else{
      QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: '',
      confirmBtnText: 'Aceptar',
      text: 'No existe ningun cliente en proceso',
      );


      print('no hay ningun cliente en proceso');
    }
    
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }



@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LTH Scanner',
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Clientes'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(color: Colors.black),
            ),
            centerTitle: true,
          ),
        body: Padding(
          padding: const EdgeInsets.only(),
                        child: ListView.builder(
                            padding: const EdgeInsets.only(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              /* return Slidable(child: null,) */
                                  return GestureDetector(
                                    onTap: ()=>{
                                      if(prefs.getInt('id') == index){
/*                                         Navigator.push(context,MaterialPageRoute(builder: (context) => Cliente()))
 */                                      }
                                    },
                                    child:Slidable(
                                      startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed:(context) {
                                                inic(index);
                                              
                                              },
                                              backgroundColor:
                                                  Colors.black45,
                                              foregroundColor: Colors.white,
                                              icon: Icons.timer,
                                              label: 'Iniciar',
                                            ),
                                          ]),
                                      
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Card(
                                          color:  prefs.getInt('id') == index ?
                                           Colors.black26:
                                           Colors.black,
                                          clipBehavior: Clip.none,
                                          /* shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ), */
                                          elevation: 0,
                                          /* shadowColor: Color.fromARGB(115, 119, 115, 115), */
                                          child: ListTile(
                                            leading: SizedBox(
                                                height: 60.0,
                                                width:
                                                    60.0, // fixed width and height
                                                child: Row(children: [                                               
                                                ])
                                                /* snap.data![index].estatus ==
                                                    0
                                                ? Image.asset(
                                                    "assets/addManifest.png")
                                                : Image.asset(
                                                    "assets/manifest.png") */
                                                ),
                                            title: Text(
                                                'Serie:\n$index',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 17)),
                                            subtitle: Text(
                                              'Generador:\n \nDomicilio:\n',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                            trailing: null,
                                            isThreeLine: true,
                                          ),
                                        ),
                                        height: 200,
                                        /* width: 150, */
                                        color:
                                            Colors.black45,
                                      )) 
                                  );
                            }),
                        /* onRefresh:  /* refreshList */, */
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
                onTap: () => {},
              ),
              SpeedDialChild(
                child:
                    const Icon(Icons.upload_file_outlined, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                onTap: () => {},
              ),
              SpeedDialChild(
                child: const Icon(Icons.sync, color: Colors.white),
                backgroundColor: Color(0xE3005CA7),
                onTap: () => {},
              ),
            ]),
      ),
    );
  }
 
}
