import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'search_screen.dart';
import 'episode_screen.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String movieTitle;
  final String videoUrl;

  const MoviePlayerScreen({
    Key? key,
    required this.movieTitle,
    required this.videoUrl,
  }) : super(key: key);

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

    // Check if the videoUrl is valid
    if (widget.videoUrl.isEmpty || !widget.videoUrl.startsWith('http')) {
      setState(() {
        errorMessage = 'Invalid video URL: ${widget.videoUrl}';
        isLoading = false;
      });
      return;
    }

    // Initialize the VideoPlayerController
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
        _controller.play(); // Auto-play the video
      }).catchError((error) {
        setState(() {
          errorMessage = 'Error loading video: $error';
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose the controller to free resources
    super.dispose();
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
            ? const CircularProgressIndicator(
                color: Colors.red,
              )
            : errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : GestureDetector(
                    onTap: () {
                      // Toggle play/pause on tap
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
      ),
      floatingActionButton: Visibility(
        // Only show the button if there's no error
        visible: errorMessage.isEmpty,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            // Toggle play/pause on button press
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
