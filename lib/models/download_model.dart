class DownloadedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String quality;
  final DateTime downloadDate;

  DownloadedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.quality,
    required this.downloadDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'quality': quality,
      'downloadDate': downloadDate.toIso8601String(),
    };
  }

  factory DownloadedMovie.fromJson(Map<String, dynamic> json) {
    return DownloadedMovie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      quality: json['quality'],
      downloadDate: DateTime.parse(json['downloadDate']),
    );
  }
}
