import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({Key? key, required this.movie, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.thumbnail.isNotEmpty
        ? movie.thumbnail
        : 'https://via.placeholder.com/500x300?text=No+Image';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Movie Title
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
