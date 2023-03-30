import 'package:animate_do/animate_do.dart';
import 'package:enermax_reparto/background/background.dart';
import 'package:enermax_reparto/db/db.dart';
import 'package:enermax_reparto/repository/funciones.dart';
import 'package:enermax_reparto/screens/home.dart';
import 'package:enermax_reparto/screens/rutas.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late String user = '';
  late String password = '';
  late bool newUser;
  late Database _database;
  late SharedPreferences loginData;
  final uri =
      Uri.parse("https://enersisuat.azurewebsites.net/api/Auth/Authenticate");
  bool isLoading = false;
//initState
  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    log("${date.year}/${date.month}/${date.day}");
  }

//Clean up controller when the widget is disposed.
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

//Login logic
  void login() async {
    loginData = await SharedPreferences.getInstance();
    Database _database = await DatabaseConnection.initiateDataBase();
    AccionRepository _accionRepo = AccionRepository(_database);
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var res = await http.post(uri,
          body: ({
            "username": usernameController.text,
            "password": passwordController.text
          }));
      print(res.statusCode);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        loginData.setBool('login', false);
        loginData.setString('username', usernameController.text);
        loginData.setString('password', passwordController.text);
        final token = body['access_token'];
        final rol = body['Roles'][0];
        loginData.setString('rol', rol);
        loginData.setString('token', token);
        loginData.setInt('id', -1);
        Map<String, dynamic> map = json.decode(res.body);
        final lista = map["Sucursales"];
        lista.forEach((element)async{
          if(element['EsCedis'].toString() == 'true'){
            loginData.setInt('cedis',int.parse(element['Id'].toString()));
          }
        });
        /* _accionRepo.limpiarClientes();
        mapController.getClientes(); */
        _openPage();
      } else {
        setState(() {
          isLoading = false;
        });
        log('Unsuccessfull');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El usuario o contraseña son incorrectos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

validate() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          login();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false);
  }

  void getToken() async {
    setState(() {
      user = loginData.getString('username')!;
      password = loginData.getString('password')!;
    });
    if (await internet()) {
      try {
        var res = await http.post(uri,
            body: ({"username": user, "password": password}));
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('token', token);
        }
      } catch (e) {
        log('error: $e');
      }
    } else {
      log('No internet connection');
    }
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/logo.png",
              height: 160,
              width: 160,),
            ),
                ),
        FadeInLeftBig(
          duration: Duration(seconds: 1),
          child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const Text(
            "Iniciar sesión",
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),),
        FadeInUp(
          duration: Duration(seconds: 1),
          child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Container(
                height: 150,
                margin: const EdgeInsets.only(
                  right: 70,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 32),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            color: Colors.black,
                            Icons.account_circle_rounded),
                          hintText: "Usuario",
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 32),
                      child:  TextFormField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            color: Colors.black,
                            Icons.password),
                          hintText: "Contraseña",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FadeInRightBig(
                  child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255,0,82,164),
                        Color.fromARGB(255,4,157,217),
                      ],
                    ),
                  ),
                  child: isLoading == false ?
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.arrow_forward_outlined),
                    color: Colors.white,
                    onPressed: () async {
                            if (usernameController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              const snackBar = SnackBar(
                                content: Text('Complete todos los campos'),
                                backgroundColor: Colors.red,
                                elevation: 10,
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (!isLoading) {
                                setState(() {
                                  isLoading = true;
                                  login();
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                  ) : Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.only(left: 0),
                                  child:  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                 
                ),)
              ),
              
            ],
          ),
        ),),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text("v 2.1.0", style: TextStyle(color: Colors.white),),
        )
        
      ],
    )
        ],
      ),
    );
  }
}
