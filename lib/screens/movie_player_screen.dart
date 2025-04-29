import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String movieTitle;
  final String videoUrl;
  final bool isYouTube; // Flag to determine if the video is a YouTube video

  const MoviePlayerScreen({
    Key? key,
    required this.movieTitle,
    required this.videoUrl,
    this.isYouTube = false,
  }) : super(key: key);

  @override
  _MoviePlayerScreenState createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isYouTube) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.videoUrl, // The YouTube video key
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(() {
          if (_youtubeController!.value.hasError) {
            setState(() {
              _isError = true;
            });
          }
        });
    } else {
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: false,
            errorBuilder: (context, errorMessage) {
              return const Center(
                child: Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );
        }).catchError((error) {
          setState(() {
            _isError = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.movieTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _isError
            ? const Text(
                'Error loading video',
                style: TextStyle(color: Colors.white),
              )
            : widget.isYouTube
                ? _youtubeController != null
                    ? YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                        onReady: () {
                          _youtubeController!.play();
                        },
                      )
                    : const CircularProgressIndicator(color: Colors.red)
                : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
}