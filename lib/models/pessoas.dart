class Pessoa {
  int id;
  String nome;
  String latitude;
  String longitude;
  String imagem;

  Pessoa(this.id, this.nome, this.latitude, this.longitude, this.imagem);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
      'imagem': imagem
    };
    return map;
  }

  Pessoa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    imagem = map['imagem'];
  }

  @override
  String toString() {
    return "Pessoa => (id:$id, nome:$nome, latitude:$latitude, longitude :$longitude)";
  }
}
