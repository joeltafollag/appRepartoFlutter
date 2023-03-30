import 'dart:convert';
import 'dart:io';

import 'package:enermax_reparto/screens/home.dart';
import 'package:enermax_reparto/screens/loading.dart';
import 'package:enermax_reparto/screens/login.dart';
import 'package:enermax_reparto/screens/login_form.dart';
import 'package:enermax_reparto/screens/rutas1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String user = '';
  late String password = '';
  late var newUser = null;
  late Database _database;
  late SharedPreferences loginData;
  final uri =
      Uri.parse("https://enersisuat.azurewebsites.net/api/Auth/Authenticate");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }
  checkLogin()async{
    await checkIfAlreadyLogin();
  }
//Check if already login
   checkIfAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      newUser = (loginData.getBool('login') ?? true);
    });
    if (newUser == false) {
      getToken();
    }
  }
  void _openPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false);
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
      }
    } else {
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: newUser == null ? Loading() : 
      newUser == false ? Rutas1() : LoginForm(),
    );
  }
}