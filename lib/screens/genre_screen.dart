import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'genre_movie_screen.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Comedy', 'image': 'assets/comedy.png'},
    {'id': 2, 'name': 'Hollywood', 'image': 'assets/hollywood.png'},
    {'id': 3, 'name': 'Nollywood', 'image': 'assets/nollywood.png'},
    {'id': 4, 'name': 'Bollywood', 'image': 'assets/bollywood.png'},
    {'id': 5, 'name': 'Animations', 'image': 'assets/animations.png'},
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<MovieProvider>(context, listen: false).fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres'),
        backgroundColor: Colors.blueAccent,
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(category['image']),
                      radius: 30,
                    ),
                    title: Text(category['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenreMoviesScreen(
                              genreId: category['id'],
                              genreName: category['name']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
