class DetallesPickUp {
  int grupoId;
  int cantidad;

  DetallesPickUp({required this.grupoId, required this.cantidad});


  Map<String,dynamic> mapForInsert(){
    return {
      'grupoId' : grupoId.toInt(),
      'cantidad': cantidad.toInt()
    };
  }

  Map<String, dynamic> toJsonAttr() => {
    'grupoId': grupoId,
    'cantidad': cantidad,
  };
}



/* class ManifiestoPickUp {
  int id;
  String firma;
  double latitud;
  double longitud;

  ManifiestoPickUp(
      {required this.id,
      required this.firma,
      required this.latitud,
      required this.longitud
      });
  Map<String,dynamic> mapForInsert(){
    return {
      'id' : id,
      'firma': firma,
      'latitud': latitud,
      'longitud': longitud
    };
  }
} */


class ManifiestoPickUp {
  int id;
  String firma;
  double latitud;
  double longitud;
  List<DetallesPickUp> detalles;


  ManifiestoPickUp(
      {required this.id,
      required this.firma,
      required this.latitud,
      required this.longitud,
      required this.detalles
      });
  Map<String,dynamic> mapForInsert(){
    return {
      'id' : id,
      'firma': firma,
      'latitud': latitud,
      'longitud': longitud
    };
  }
}