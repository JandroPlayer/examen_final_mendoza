import 'dart:convert';

/* Json pokemon fake api
{
    "id": 1,
    "name": "bulbasaur",
    "tipus": "planta",
    "descripcio": "Pokemon flor",
    "photo": "https://oncl.gumlet.io/graphics/exam-pass-guarantee.gif"
}
*/
class Pokemon {
  int? id;
  String name;
  String tipus;
  String descripcio;  
  String photo;
  
  Pokemon({
    this.id,
    required this.name,
    required this.tipus,
    required this.descripcio,
    required this.photo,
  });

  factory Pokemon.fromJson(String str) => Pokemon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pokemon.fromMap(Map<String, dynamic> json) => Pokemon(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        tipus: json["tipus"] ?? '',
        descripcio: json["descripcio"] ?? '',
        photo: json["photo"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "tipus": tipus,
        "descripcio": descripcio,
        "photo": photo,
      };

  Pokemon copy() => Pokemon(
        id: id,
        name: name,
        tipus: tipus,
        descripcio: descripcio,
        photo: photo,
      );

  Pokemon copyWith({
    int? id,
    String? name,
    String? tipus,
    String? descripcio,
    String? photo,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      tipus: tipus ?? this.tipus,
      descripcio: descripcio ?? this.descripcio,
      photo: photo ?? this.photo,
    );
  }
}
