import 'package:animate_do/animate_do.dart';
import 'package:animated_list_item/animated_list_item.dart';
import 'package:enermax_reparto/models/task.dart';
import 'package:enermax_reparto/Widgets/card_widget.dart';
import 'package:enermax_reparto/screens/cliente.dart';
import 'package:enermax_reparto/screens/home.dart';
import 'package:enermax_reparto/screens/login_form.dart';
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

class Rutas1 extends StatefulWidget {
  const Rutas1({Key? key}) : super(key: key);

  @override
  State<Rutas1> createState() => _HomePageState();
}

class _HomePageState extends State<Rutas1> with SingleTickerProviderStateMixin {
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                            onTap: () async {
                                      final login =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        login.clear();
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginForm()),
                                          (route) => false);
                                    },
                                            child: Icon(
                                              Icons.logout_outlined,
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
                        'RUTAS',
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
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
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
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
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
