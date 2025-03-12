import 'package:flutter/material.dart';

void main() {
  runApp(EpisodeScreen());
}

class EpisodeScreen extends StatelessWidget {
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
              SizedBox(height: 50),
              Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 100,
                  color: Colors.white38,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Disney’s Aladdin",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "2019 • Adventure, Comedy • 2h 8m",
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ),
              SizedBox(height: 20),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Play", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Download", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Aladdin, a street boy who falls in love with a princess. With differences in caste and wealth, Ala... Read more",
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Episode", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  Text("Similar", style: TextStyle(color: Colors.white60)),
                  SizedBox(width: 20),
                  Text("About", style: TextStyle(color: Colors.white60)),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 4,
                width: 60,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.play_arrow, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Trailer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(
                                  "Aladdin, a street boy who falls in love with a princess. With differences in caste and wealth, Aladdin tries to...",
                                  style: TextStyle(color: Colors.white60),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}