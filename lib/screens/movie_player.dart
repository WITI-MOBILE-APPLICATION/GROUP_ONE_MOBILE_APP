import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String movieTitle;
  final String videoUrl;

  const MoviePlayerScreen(
      {Key? key, required this.movieTitle, required this.videoUrl})
      : super(key: key);

  @override
  _MoviePlayerScreenState createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Validate the video URL first
    if (widget.videoUrl.isEmpty || !widget.videoUrl.startsWith('http')) {
      setState(() {
        errorMessage = 'Invalid video URL';
        isLoading = false;
      });
      return;
    }

    // Initialize the video player controller
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
        _controller.play(); // Start playing automatically after initialization
      }).catchError((error) {
        setState(() {
          errorMessage = 'Error loading video: $error';
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Properly dispose of the controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.movieTitle),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show loading spinner while video is buffering
            : errorMessage.isNotEmpty
                ? Text(errorMessage,
                    style: TextStyle(color: Colors.red)) // Show error message
                : AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
