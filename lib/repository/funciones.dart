import 'package:enermax_reparto/models/check_in.dart';
import 'package:enermax_reparto/models/manifiestoDetalle.dart';
import 'package:enermax_reparto/models/manifiestos.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


import '../models/clientes.dart';
import '../models/clientesDia.dart';
class AccionRepository{
  late Database _database;
  AccionRepository(Database pdatabase){
    _database = pdatabase;
  }

  Future<List<clientesDia>> getAllAcciones(int dia) async {
    List result = await _database.rawQuery('SELECT * FROM clientes WHERE dia = ?',
    [dia]);
    var lista = result.map((item) => clientesDia(int.parse(item['dia'].toString()),int.parse(item['id'].toString()),int.parse(item['orden'].toString()),item['nombre'],int.parse(item['agenteId'].toString()),item['domicilio'],double.parse(item['latitud'].toString()),double.parse(item['longitud'].toString()),int.parse(item['checado'].toString()))).toList();
    return lista;
  }
  Future<List<clientesDia>> getAllAccionesN() async {
    List result = await _database.rawQuery('SELECT * FROM clientes');
     var lista = result.map((item) => clientesDia(int.parse(item['dia'].toString()),int.parse(item['id'].toString()),int.parse(item['orden'].toString()),item['nombre'],int.parse(item['agenteId'].toString()),item['domicilio'],double.parse(item['latitud'].toString()),double.parse(item['longitud'].toString()),int.parse(item['checado'].toString()))).toList();
    return lista;
  }
  Future<List<check_inn>> getAllCheck() async {
    List result = await _database.rawQuery('SELECT * FROM check_inn');
/*     print(result);
 */    var lista = result.map((item) => check_inn(int.parse(item['dia'].toString()),int.parse(item['id'].toString()),double.parse(item['latitud'].toString()),double.parse(item['longitud'].toString()),item['title'], item['snippet'])).toList();
    return lista;
  }
  Future<List<manifiestos>> getAllManifiestos() async {
    List result = await _database.rawQuery('SELECT * FROM manifiesto');
/*     print(result);
 */    var lista = result.map((item) => manifiestos(Id:int.parse(item['Id'].toString()),Serie:item['Serie'],Generador:item['Generador'],Domicilio:item['Domicilio'],Hash:item['Hash'],Firma:item['Firma'],Longitud:item['Longitud'],Latitud:item['Latitud'], estatus: item['estatus'])).toList();
    return lista;
  }
  Future<List<manifiestoDetalle>> getAllManifiestosFetalle(int id) async {
    List result = await _database.rawQuery('SELECT * FROM manifiestoDetalle WHERE IdManifiesto = ?',
    [id]);
/*     print(result);
 */    var lista = result.map((item) => manifiestoDetalle(IdManifiesto:int.parse(item['IdManifiesto'].toString()) ,ArticuloId: int.parse(item['ArticuloId'].toString()),Cantidad: int.parse(item['Cantidad'].toString()),GrupoId: int.parse(item['GrupoId'].toString()))).toList();
    return lista;
    print("________________________________________$id");
    print(lista);
  }
  Future<List<manifiestoDetalle>> getAllManifiestosFetalleQr(String hash) async {
    List result = await _database.rawQuery('SELECT * FROM manifiestoDetalle WHERE  IdManifiesto = (SELECT Id FROM manifiesto WHERE Hash=?)',
    [hash]);
/*     print(result);
 */    var lista = result.map((item) => manifiestoDetalle(IdManifiesto:int.parse(item['IdManifiesto'].toString()) ,ArticuloId: int.parse(item['ArticuloId'].toString()),Cantidad: int.parse(item['Cantidad'].toString()),GrupoId: int.parse(item['GrupoId'].toString()))).toList();
    return lista;
    print("________________________________________$hash");
    print(lista);
  }
  Future<List<manifiestos>> getManifiestoQr(String hash) async {
    List result = await _database.rawQuery('SELECT * FROM manifiesto WHERE Hash=?',
    [hash]);
/*     print(result);
 */    var lista = result.map((item) => manifiestos(Id:int.parse(item['Id'].toString()),Serie:item['Serie'],Generador:item['Generador'],Domicilio:item['Domicilio'],Hash:item['Hash'],Firma:item['Firma'],Longitud:double.parse(item['Longitud'].toString()),Latitud:double.parse(item['Latitud'].toString()),estatus: item['estatus'])).toList();
    return lista;
    print("________________________________________$hash");
    print(lista);
  }

  register(clientesDia accion) async {
    var map = accion.mapForInsert();
    await _database.insert("clientes", map);
  }
  registerCheck(check_inn check) async {
    var map = check.mapForInsert();
    await _database.insert("check_inn", map);
  }
  insertarManifiesto(manifiestos manifiestos) async {
    var map = manifiestos.mapForInsert();
    await _database.insert("manifiesto", map);
  }
  insertarManifiestoDetalle(manifiestoDetalle manifiestoDetalle) async {
    var map = manifiestoDetalle.mapForInsert();
    await _database.insert("manifiestoDetalle", map);
  }
  delete(int id) async {
    var count = await _database.rawDelete(
        'DELETE FROM clientes');
  }
  deleteManifiesto(int id) async {
    var count = await _database.rawDelete(
        'DELETE FROM clientes');
  }
  deleteCheck(int id) async {
    var count = await _database.rawDelete(
        'DELETE FROM check_inn WHERE id = ?',
        [id]);
  }
  update(int id) async{
     var count = await _database.rawUpdate(
      'UPDATE clientes SET  checado = ? WHERE id = ?',
      [1,id]
    );    
  }
  updateCheck(int id) async{
     var count = await _database.rawUpdate(
      'UPDATE clientes SET  checado = ? WHERE id = ?',
      [0,id]
    );    
  }
  updateManifiesto(manifiestos manifiestos) async{
     var count = await _database.rawUpdate(
      'UPDATE manifiesto SET Firma = ?, Longitud = ?,Latitud = ?, estatus = ? WHERE Id = ?',
      [manifiestos.Firma,manifiestos.Longitud,manifiestos.Latitud,manifiestos.estatus ,manifiestos.Id]
    );    
  }
  updateManifiestoEstado(int id) async{
     var count = await _database.rawUpdate(
      'UPDATE manifiesto SET estatus = ? WHERE Id = ?',
      [2,id]
    );    
  }
  procesoManifiestoEstado(int id) async{
     var count = await _database.rawUpdate(
      'UPDATE manifiesto SET estatus = ? WHERE Id = ?',
      [1,id]
    );    
  }

}




