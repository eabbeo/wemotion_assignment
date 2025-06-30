import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';


class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool isCurrentItem;

  const VideoPlayerWidget(
    this.videoUrl, {
    this.autoPlay = true,
    this.isCurrentItem = true,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerPlusController _controller;
  bool _isInitialized = false;
  bool _shouldPlay = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller =
        CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(widget.videoUrl),
            httpHeaders: {'Connection': 'keep-alive'},
            invalidateCacheIfOlderThan: const Duration(days: 10),
          )
          ..addListener(_controllerListener)
          ..initialize().then((_) {
            if (mounted) {
              setState(() => _isInitialized = true);
              if (widget.autoPlay && widget.isCurrentItem) {
                _playVideo();
              }
            }
          });
  }

  void _controllerListener() {
    if (!mounted) return;

    // Handle video state changes if needed
    if (_controller.value.isPlaying != _shouldPlay) {
      setState(() {});
    }
  }

  Future<void> _playVideo() async {
    if (!_isInitialized) return;
    try {
      await _controller.play();
      await _controller.setLooping(true);
      setState(() => _shouldPlay = true);
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  Future<void> _pauseVideo() async {
    if (!_isInitialized) return;
    try {
      await _controller.pause();
      setState(() => _shouldPlay = false);
    } catch (e) {
      debugPrint('Error pausing video: $e');
    }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle video URL changes
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.removeListener(_controllerListener);
      _controller.dispose();
      _initializeController();
    }

    // Handle play/pause based on visibility
    if (oldWidget.isCurrentItem != widget.isCurrentItem) {
      if (widget.isCurrentItem && widget.autoPlay) {
        _playVideo();
      } else {
        _pauseVideo();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        children: [
          CachedVideoPlayerPlus(_controller),
          if (!_shouldPlay && widget.isCurrentItem)
            Center(
              child: IconButton(
                icon: const Icon(Icons.play_arrow, size: 50),
                onPressed: _playVideo,
              ),
            ),
        ],
      ),
    );
  }
}
