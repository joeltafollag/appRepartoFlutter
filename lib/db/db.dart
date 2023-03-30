//Import sqflite and async
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseConnection{
 late Database _database;

  static initiateDataBase() async{
    return await openDatabase('db_crud.db', version:1,
        onCreate: (Database db, int version){
          var sqlCreate = sqlCreateDatabase();
           db.execute(sqlCreate);
           var sqlCreate1 = sqlCreateDatabase1();
           db.execute(sqlCreate1);
           var sqlCreateManifiesto = sqlCreateTableManifiesto();
           db.execute(sqlCreateManifiesto);
           var sqlCreateManifiestoDetalle = sqlCreateTableManifiestoDetalle();
           db.execute(sqlCreateManifiestoDetalle);
        });
  }

  static String sqlCreateDatabase(){
  return 'CREATE TABLE IF NOT EXISTS clientes(dia INT, id INT UNIQUE, orden INT, nombre TEXT, agenteId INT, domicilio TEXT, latitud FLOAT, longitud FLOAT, checado INT)';
  }
  static String sqlCreateDatabase1(){
  return 'CREATE TABLE IF NOT EXISTS check_inn(dia INT, id INT, latitud FLOAT, longitud FLOAT, title TEXT, snippet TEXT)';
  }
  static String sqlCreateTableManifiesto(){
  return 'CREATE TABLE IF NOT EXISTS manifiesto(Id INT UNIQUE, Serie TEXT, Generador TEXT, Domicilio TEXT, Hash TEXT,Firma TEXT,Longitud FLOAT,Latitud FLOAT, estatus INT)';
  }
  static String sqlCreateTableManifiestoDetalle(){
  return 'CREATE TABLE IF NOT EXISTS manifiestoDetalle(IdManifiesto INT, GrupoId INT, ArticuloId INT, Cantidad INT)';
  }
  void close(){
    _database.close();
  }
  
}
  

