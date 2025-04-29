import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie_player_screen.dart';

class EpisodeScreen extends StatefulWidget {
  final String tvId;
  final String apiKey;
  final String title;
  final String overview;
  final String metadata;

  const EpisodeScreen({
    Key? key,
    required this.tvId,
    required this.apiKey,
    required this.title,
    required this.overview,
    required this.metadata,
  }) : super(key: key);

  @override
  _EpisodeScreenState createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  List<dynamic> episodes = [];
  bool isLoading = true;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  String? trailerKey; // Store the YouTube video key for the trailer

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
    fetchTrailer(); // Fetch the trailer for the TV show
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
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load episodes');
    }
  }

  Future<void> fetchTrailer() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/tv/${widget.tvId}?api_key=${widget.apiKey}&append_to_response=videos'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = data['videos']['results'] as List<dynamic>?;
      final trailer = videos?.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      setState(() {
        trailerKey = trailer != null ? trailer['key'] : null;
      });
    } else {
      throw Exception('Failed to load trailer');
    }
  }

  Future<void> downloadEpisode(String episodeId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading episode $episodeId...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF06041F),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF06041F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 100,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.metadata,
                  style: const TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (trailerKey != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoviePlayerScreen(
                              movieTitle: widget.title,
                              videoUrl: trailerKey!,
                              isYouTube: true,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No trailer available')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Play", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Download", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.overview,
                style: const TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Episode",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Text("Similar", style: TextStyle(color: Colors.white60)),
                  SizedBox(width: 20),
                  Text("About", style: TextStyle(color: Colors.white60)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 60,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.red))
                    : episodes.isEmpty
                        ? const Center(
                            child: Text(
                              'No episodes found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: episodes.length,
                            itemBuilder: (context, index) {
                              final episode = episodes[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (trailerKey != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MoviePlayerScreen(
                                            movieTitle: episode['name'] ?? 'Episode',
                                            videoUrl: trailerKey!,
                                            isYouTube: true,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No trailer available')),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          episode['still_path'] != null
                                              ? '$imageBaseUrl${episode['still_path']}'
                                              : 'https://via.placeholder.com/100x150',
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 150,
                                              color: Colors.grey[800],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              episode['name'] ?? 'Episode',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              episode['overview'] != null
                                                  ? episode['overview'].length > 100
                                                      ? '${episode['overview'].substring(0, 100)}...'
                                                      : episode['overview']
                                                  : 'No description available',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (trailerKey != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MoviePlayerScreen(
                                                      movieTitle: episode['name'] ?? 'Episode',
                                                      videoUrl: trailerKey!,
                                                      isYouTube: true,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('No trailer available')),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Play',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              downloadEpisode(episode['id'].toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white24,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Download',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}