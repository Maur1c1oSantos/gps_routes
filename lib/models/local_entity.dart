class LocalEntity {
  final int? id;
  final String latitude;
  final String longitude;
  final String rua;
  final int idRota;

  LocalEntity({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.rua,
    required this.idRota,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'rua': rua,
      'idRota': idRota,
    };
  }

  @override
  String toString() {
    return 'Pessoa{id: $id, latitude: $latitude, longitude: $longitude, rua: $rua, idRota: $idRota}';
  }
}
