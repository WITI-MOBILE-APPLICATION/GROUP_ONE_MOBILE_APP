class Movie {
  final int id;
  final String title;
  final String thumbnail;
  final String poster;
  final double rating;
  final String releaseDate;
  final String description;

  Movie({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.poster,
    required this.rating,
    required this.releaseDate,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json, String imageBaseUrl) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      thumbnail: json['poster_path'] != null
          ? '$imageBaseUrl${json['poster_path']}'
          : '',
      poster: json['poster_path'] != null
          ? '$imageBaseUrl${json['poster_path']}'
          : '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown',
      description: json['overview'] ?? 'No Description Available',
    );
  }
}
