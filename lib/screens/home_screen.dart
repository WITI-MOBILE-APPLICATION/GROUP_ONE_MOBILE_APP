import 'package:flutter/material.dart';
import 'package:my_app/models/movie.dart';
import 'package:my_app/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_title.dart';
import 'genre_screen.dart';
import 'episode_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieProvider>(context, listen: false).fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('MovieVault',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GenreScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          ),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrendingMovies(movieProvider),
                  const SectionTitle(title: 'Top Rated Movies'),
                  _buildHorizontalMovieList(movieProvider.topRatedMovies),
                  const SectionTitle(title: 'Upcoming Movies'),
                  _buildHorizontalMovieList(movieProvider.upcomingMovies),
                ],
              ),
            ),
    );
  }

  /// 🔥 **Trending Movies with Hero Animation**
  Widget _buildTrendingMovies(MovieProvider movieProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Trending Now'),
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: movieProvider.trendingMovies.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final movie = movieProvider.trendingMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Hero(
                  tag: 'movie_${movie.id}',
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(movie.poster),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 🎬 **Reusable Movie List (Horizontal Scrolling)**
  Widget _buildHorizontalMovieList(List<Movie> movies) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search results for "$query"'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search for movies'));
  }
}

//  import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
//   final String baseUrl = 'https://api.themoviedb.org/3/movie/latest';
//   Map<String, dynamic>? latestMovie;

//   @override
//   void initState() {
//     super.initState();
//     fetchLatestMovie();
//   }

//   Future<void> fetchLatestMovie() async {
//     final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey'));

//     if (response.statusCode == 200) {
//       setState(() {
//         latestMovie = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load latest movie');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Latest Movie'),
//       ),
//       body: latestMovie == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     latestMovie!['title'] ?? 'No title available',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Release Date: ${latestMovie!['release_date'] ?? 'Unknown'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     latestMovie!['overview'] ?? 'No description available',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
