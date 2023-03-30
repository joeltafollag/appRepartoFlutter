class manifiestos{
  int Id;
  String Serie;
  String Generador;
  String Domicilio;
  String Hash;
  String Firma;
  double Latitud;
  double Longitud;
  int estatus;

  manifiestos({
      required this.Id,
      required this.Serie,
      required this.Generador,
      required this.Domicilio,
      required this.Hash,
      required this.Firma,
      required this.Latitud,
      required this.Longitud,
      required this.estatus
});

factory manifiestos.fromJson(Map json){
  return manifiestos(
    Id : json['Id'],
    Serie : json['Serie'],
    Generador : json['Generador'],
    Domicilio : json['Domicilio'],
    Hash : json['Hash'],
    Firma: json['Firma'] == null ? "" : json["Firma"],
    Latitud: json['Latitud'] == null ? 0.0 : json["Latitud"],
    Longitud: json['Longitud'] == null ? 0.0 : json["Longitud"],
    estatus: json['estatus']
  );
}
Map<String,dynamic> mapForInsert(){
    return {
      'Id' : Id.toInt(),
      'Serie': Serie.toString(),
      'Generador': Generador.toString(),
      'Domicilio': Domicilio.toString(),
      'Hash': Hash.toString(),
      'Firma' : Firma.toString(),
      'Longitud': Longitud.toDouble(),
      'Latitud': Latitud.toDouble(),
      'estatus' : estatus
    };
  }



}
        