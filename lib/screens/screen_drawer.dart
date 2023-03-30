import 'package:enermax_reparto/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenDrawer extends StatefulWidget {
  const ScreenDrawer({Key? key}) : super(key: key);

  @override
  _ScreenDrawerState createState() => _ScreenDrawerState();
}

class _ScreenDrawerState extends State<ScreenDrawer> {
  late SharedPreferences logindata;

  @override
  void initState(){
    super.initState();
    initial();
  }
  void initial()async{
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xE3005CA7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF75ACEB),
                  Color(0xE0458EB8),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ListTile(
            leading: Icon(
              Icons.logout, color: Colors.white
            ),
            title: Text("Cerrar sesion", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onTap: () {
                      logindata.setBool('login', true);
                      logindata.setString('token', "");
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => MyLoginPage()));
                    },
          ),
          ],
        ),
      ),
    );
  }
}

class _ListTitleWiidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const _ListTitleWiidget({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: const TextStyle(
            fontFamily: 'Barlow', fontSize: 16.0, color: Colors.black),
      ),
    );
  }
}
