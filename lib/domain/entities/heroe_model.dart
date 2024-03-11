//Para esta entidad se almacenan solo los datos necesarios para la aplicacion, y se implementa un metodo para convertir el json en un objeto de la clase HeroeModel, y otro para convertir el objeto en un mapa para poder almacenarlo en el storage de GetStorage y un metodo para llenar el modelo usando la informacion almacenada en el storage.

class HeroeModel {
  final int id;
  final String name;
  final String description;
  final String image;
  HeroeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory HeroeModel.fromJson(Map<String, dynamic> json) {
    return HeroeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
    );
  }

  factory HeroeModel.fromStore(Map<String, dynamic> map) {
    return HeroeModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  HeroeModel copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
  }) {
    return HeroeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
