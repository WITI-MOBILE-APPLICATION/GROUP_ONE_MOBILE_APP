import 'dart:convert'; // For json.decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'movie_player.dart'; // Make sure this is the correct import path for MoviePlayerScreen

void main() {
  runApp(EpisodeScreen());
}

class EpisodeScreen extends StatefulWidget {
  @override
  _EpisodeScreenState createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  List<dynamic> episodes = [];
  bool isLoading = true;
  String tvId = "123"; // Replace with the actual TV ID you need
  String apiKey =
      "ab0608ff77e9b69c9583e1e673f95115"; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/tv/$tvId/season/1?api_key=$apiKey'),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 100,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Disney’s Aladdin",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const Center(
                child: Text(
                  "2019 • Adventure, Comedy • 2h 8m",
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child:
                          Text("Play", style: TextStyle(color: Colors.white)),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text("Download",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Aladdin, a street boy who falls in love with a princess. With differences in caste and wealth, Ala... Read more",
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Episode",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
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
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          final episode = episodes[index];
                          return ListTile(
                            title: Text(episode['name'] ?? 'Episode'),
                            subtitle:
                                Text(episode['overview'] ?? 'No description'),
                            onTap: () {
                              // Handle episode playback
                              String episodeUrl =
                                  'https://your_video_source.com/${episode['id']}.mp4'; // Replace with actual video URL
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoviePlayerScreen(
                                    movieTitle: episode['name'] ?? 'Episode',
                                    videoUrl: episodeUrl,
                                  ),
                                ),
                              );
                            },
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
