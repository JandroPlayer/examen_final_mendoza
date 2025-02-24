import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ScanModel {
  int id;
  String valor;

  ScanModel({
    required this.id,
    required this.valor,
  });

  LatLng getLatLng() {
    final latLng = valor.split(',');
    final lat = double.parse(latLng[0]);
    final lng = double.parse(latLng[1]);
    return LatLng(lat, lng);
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,
      };
}