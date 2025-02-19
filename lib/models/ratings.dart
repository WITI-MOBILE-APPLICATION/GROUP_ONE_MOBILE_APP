class Ratings {
  final double average;
  final int count;

  Ratings({
    required this.average,
    required this.count,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      count: json['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vote_average': average,
      'vote_count': count,
    };
  }
}



// class Ratings {
//   final double average;
//   final int count;

//   Ratings({
//     required this.average,
//     required this.count,
//   });

//   factory Ratings.fromJson(Map<String, dynamic> json) {
//     return Ratings(
//       average: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
//       count: json['vote_count'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'vote_average': average,
//       'vote_count': count,
//     };
//   }
// }

