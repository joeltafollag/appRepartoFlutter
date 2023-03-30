/* import 'package:animate_do/animate_do.dart';
import 'package:enermax_reparto/screens/manifiestos.dart';
import 'package:enermax_reparto/screens/rutas.dart';
import 'package:enermax_reparto/screens/screen_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Home",
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (_index) {
      case 0:
        child = Rutas();
        break;
      /* case 1:
        child = MapScreen();
        break;
      case 2:
        child = MisDatos();
      break; */
    }

    return ZoomIn(
        duration: Duration(seconds: 1),
        child: Scaffold(
          drawer: const ScreenDrawer(),
          appBar: AppBar(
            title: const Text(''),
            flexibleSpace: Container(
              decoration: const BoxDecoration(color: Color(0xE3005CA7),),
            ),
            centerTitle: true,
          ),
          body: SizedBox.expand(child: child),
          bottomNavigationBar: CurvedNavigationBar(
            key: navigationKey,
            height: 50.0,
            color: Color(0xE3005CA7),
            buttonBackgroundColor: Color(0xE3005CA7),
            backgroundColor: Colors.white,
            animationDuration: const Duration(milliseconds: 400),
            onTap: (int index) => setState(() => _index = index),
            items: [
              Icon(Icons.bookmark_add_sharp, color: Colors.white),
            ],
          ),
        ));
  }
}
 */

import 'package:animate_do/animate_do.dart';
import 'package:animated_list_item/animated_list_item.dart';
import 'package:enermax_reparto/models/task.dart';
import 'package:enermax_reparto/Widgets/card_widget.dart';
import 'package:enermax_reparto/screens/cliente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db.dart';
import '../models/manifiestos.dart';
import '../repository/funciones.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
  final newList = listTask.toList();
  final meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  var date = DateTime.now();
  late AnimationController _animationController;
  static late SharedPreferences prefs;
  int id = -1;
  static late double progreso = 0;
  late Database _database;
  late AccionRepository _accionRepo;
  List<manifiestos> manifiestosList =List.empty();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animationController.forward();
    initVariables();
  }
  

  initVariables() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('id') != -1){
            setState(() {
              id=prefs.getInt('id')!;
            });
    } 
    _database = await DatabaseConnection.initiateDataBase();
    _accionRepo = AccionRepository(_database);
    manifiestosList = await _accionRepo.getAllManifiestos();
    setState(() {
      manifiestosList;
      prefs;
    });
    calcularProgreso();
  }
  calcularProgreso(){
    int completado=0;
    manifiestosList.forEach((element) { 
      if(element.estatus == 2){
        completado++;
      }
    });
    progreso = completado/manifiestosList.length;
    setState(() {
      progreso;
    });
  }
  refresh()async{
    manifiestosList = await _accionRepo.getAllManifiestos();
    setState(() {
      manifiestosList;
    });
    calcularProgreso();
  }
  cambiarEstatus(int id) {
    _accionRepo.procesoManifiestoEstado(id);
    refresh();
      /* QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: '',
      confirmBtnText: 'Aceptar',
      text: 'Ya existe un cliente en proceso',
      );
      print('Error de cliente'); */
    /*  */
    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: size.width,
                  height: size.height / 3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                      right: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 140, 221, 1),
                        Color.fromRGBO(0, 82, 164, 1),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:50),
                        child: 
                        Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_back_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                        'RUTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                                      ],
                                    )   
                                  ],
                                ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: new CircularPercentIndicator(
                                radius: 35,
                                animationDuration: 2000,
                                lineWidth: 5.0,
                                animation: true,
                                percent: progreso,
                                backgroundColor:
                                    Colors.white, //backround of progress bar
                                circularStrokeCap: CircularStrokeCap
                                    .round, //corner shape of progress bar at start/end
                                progressColor: Colors.lightGreen,
                                center: new Text(
                                  (progreso*100).round().toString()+'%',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: Colors.white),
                                )),
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(1),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          "Jose Perez Hernandez",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          "${date.day} de ${meses[date.month - 1]} del ${date.year}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.height / 4.4,
                left: 16,
                child: Container(
                  width: size.width - 32,
                  height: size.height / 1.3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                      right: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: manifiestosList.isEmpty ?
                    Container() :
                    ListView.separated(
                      itemCount: manifiestosList.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 4,
                        );
                      },
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      itemBuilder: (context, index) {
                        return AnimatedListItem(
                            index: index,
                            length: manifiestosList.length,
                            aniController: _animationController,
                            animationType: AnimationType.slideIn,
                            startX: 40,
                            startY: 60,
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  if(manifiestosList[index].estatus == 0)
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(16),
                                    onPressed: (_) {
                                      /* cambiarEstatus(newList[index].id); */
                                      cambiarEstatus(manifiestosList[index].Id);
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => Cliente(manifiesto: manifiestosList[index],)));
                                    },
                                    backgroundColor: Color(0xff2da9ef),
                                    foregroundColor: Colors.white,
                                    icon: Icons.timer,
                                    label: 'Iniciar',
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
              onTap: () {
                if(manifiestosList[index].estatus == 1){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Cliente(manifiesto: manifiestosList[index],)));
                }
              },
              child: CardWidget(
                                manifiestosList: manifiestosList[index],
                              ),
            ),
                            ));
                      },
                    ),
                    )
                  ),
                ),
            ],
          ),
        ));
  }
}
