import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

/* void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(),
    );
  }
} */

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  late SharedPreferences logindata;
  late bool usuario_nuevo;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    checar_login();
  }

  void checar_login() async {
    logindata = await SharedPreferences.getInstance();
    usuario_nuevo = (logindata.getBool('login') ?? true);
    print(usuario_nuevo);
    if (usuario_nuevo == false) {
      /* Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => MyDashboard())); */
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    }
  }

  @override
  void dispose() {
    // Limpiar el controlador.
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }
  void login() async {
    String username = username_controller.text;
    String password = password_controller.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      var response = await http.post(Uri.parse("https://enersisuat.azurewebsites.net/api/Auth/Authenticate"),
          body: ({"username": username, "password": password}));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        var token = body["access_token"];
        logindata.setBool('login', false);
        logindata.setString('token', token);
        Map<String, dynamic> map = json.decode(response.body);
        final lista = map["Sucursales"];
        lista.forEach((element)async{
          if(element['EsCedis'].toString() == 'true'){
            logindata.setInt('cedis',int.parse(element['Id'].toString()));
          }
        });
         
 /* Navigator.push(context, MaterialPageRoute(builder: (context) => MyDashboard())); */
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else {
        final snackBar = SnackBar(
          content: const Text('El usuario o contraseña son incorrectos!'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: new Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        // ignore: unnecessary_const
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6E86E7),
            Color(0xE3005CA7),
          ],
        ),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ZoomIn(
                duration: Duration(seconds: 1),
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: FadeInDown(
                  duration: Duration(seconds: 1),
                  child: TextField(
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: username_controller,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.white60),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'Correo',
                          labelStyle: TextStyle(color: Colors.white)),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: FadeInUp(
                  duration: Duration(seconds: 1),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    controller: password_controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.white60),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.white)),
                    autocorrect: false,
                    obscureText: true,
                  ),
                )),
            new SizedBox(
                width: 150.0,
                height: 40.0,
                child: ZoomIn(
                    duration: Duration(seconds: 1),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 0, 82, 164),
                          textStyle: TextStyle(fontSize: 15),
                          minimumSize: Size.fromHeight(72),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          if (username_controller.text.isEmpty ||
                              password_controller.text.isEmpty) {
                            final snackBar = SnackBar(
                              content: const Text('Complete todos los campos!'),
                              backgroundColor: Colors.red,
                              elevation: 10,
                              duration: new Duration(seconds: 4),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            if (isLoading) return;
                            setState(() => isLoading = true);
                            login();
                            await Future.delayed(Duration(seconds: 2));
                            setState(() => isLoading = false);
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              )
                            : Text('Iniciar sesion')
                            )
                            ),
                            )
          ],
        ),
      )),
    ));
  }
}
