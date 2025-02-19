class Genre {
  final int id;
  final String name;
  final String? description;
  final String? image;

  Genre({required this.id, required this.name, this.description, this.image});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "No description available",
      image: json['image'],
    );
  }
}








// class Genre {
//   final int id;
//   final String name;
//   final String? description;
//   final String? image;

//   Genre({required this.id, required this.name, this.description, this.image});

//   factory Genre.fromJson(Map<String, dynamic> json, String imageBaseUrl) {
//     return Genre(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'] ?? "No description available",
//       image: json['image'] != null ? '$imageBaseUrl${json['image']}' : null, // Add the base URL to the image if available
//     );
//   }
// }

