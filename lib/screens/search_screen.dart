import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  final String apiKey;

  const SearchScreen({Key? key, required this.apiKey}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final String searchUrl = 'https://api.themoviedb.org/3/search/multi';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('$searchUrl?api_key=${widget.apiKey}&query=$query'),
    );

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to fetch search results');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      appBar: AppBar(
        backgroundColor: Color(0xFF06041F),
        title: const Text('Search Movies & TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a movie or TV show...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: searchMovies,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: searchResults.isEmpty
                        ? const Center(
                            child: Text('No results found.',
                                style: TextStyle(color: Colors.white)),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final item = searchResults[index];
                              return GestureDetector(
                                onTap: () => _navigateToDetails(context, item),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item['poster_path'] != null
                                        ? '$imageBaseUrl${item['poster_path']}'
                                        : 'https://via.placeholder.com/500x750',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, dynamic item) {
    String videoUrl = "https://your_video_source.com/${item['id']}.mp4"; // Replace with actual streaming source

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => item['media_type'] == 'movie'
            ? MoviePlayerScreen(
                movieTitle: item['title'] ?? 'Unknown',
                videoUrl: videoUrl,
              )
            : EpisodeListScreen(apiKey: widget.apiKey, tvId: item['id']),
      ),
    );
  }
}

class MoviePlayerScreen extends StatelessWidget {
  final String movieTitle;
  final String videoUrl;

  const MoviePlayerScreen({Key? key, required this.movieTitle, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movieTitle)),
      body: Center(
        child: Text('Play movie: $movieTitle (Add player here)'),
        // Add VideoPlayer widget here to play the movie using the videoUrl
      ),
    );
  }
}

class EpisodeListScreen extends StatefulWidget {
  final String apiKey;
  final int tvId;

  const EpisodeListScreen({Key? key, required this.apiKey, required this.tvId}) : super(key: key);

  @override
  _EpisodeListScreenState createState() => _EpisodeListScreenState();
}

class _EpisodeListScreenState extends State<EpisodeListScreen> {
  List<dynamic> episodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/tv/${widget.tvId}/season/1?api_key=${widget.apiKey}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        episodes = json.decode(response.body)['episodes'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load episodes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Episodes')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                return ListTile(
                  title: Text(episode['name'] ?? 'Episode'),
                  subtitle: Text(episode['overview'] ?? 'No description'),
                  onTap: () => print('Play episode ${episode['name']}'),
                );
              },
            ),
    );
  }
}
