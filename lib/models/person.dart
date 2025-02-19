class Person {
  final int id;
  final String name;
  final String image;

  Person({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      image: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': image,
    };
  }
}


// class Person {
//   final int id;
//   final String name;
//   final String image;

//   Person({
//     required this.id,
//     required this.name,
//     required this.image,
//   });

//   factory Person.fromJson(Map<String, dynamic> json, String imageBaseUrl) {
//     return Person(
//       id: json['id'],
//       name: json['name'] ?? 'Unknown',
//       image: json['profile_path'] != null
//           ? '$imageBaseUrl${json['profile_path']}'
//           : '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'profile_path': image,
//     };
//   }
// }

