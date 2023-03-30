class manifiestoDetalle{
  int IdManifiesto;
  int GrupoId;
  int ArticuloId;
  int Cantidad;

  manifiestoDetalle({
      required this.IdManifiesto,
      required this.GrupoId,
      required this.ArticuloId,
      required this.Cantidad,
});

factory manifiestoDetalle.fromJson(Map json){
  return manifiestoDetalle
(
    IdManifiesto : json['IdManifiesto'],
    GrupoId : json['GrupoId']== null ? 0 : json["GrupoId"],
    ArticuloId : json['ArticuloId'] == null ? 0 : json["ArticuloId"],
    Cantidad : json['Cantidad'],
  );

}
Map<String,dynamic> mapForInsert(){
    return {
      'IdManifiesto' : IdManifiesto.toInt(),
      'GrupoId': GrupoId.toInt(),
      'ArticuloId': ArticuloId.toInt(),
      'Cantidad': Cantidad.toInt()
    };
  }
  Map<String, dynamic> toJsonAttr() => {
    'IdManifiesto' : IdManifiesto,
      'GrupoId': GrupoId,
      'ArticuloId': ArticuloId,
      'Cantidad': Cantidad
  };

}
        