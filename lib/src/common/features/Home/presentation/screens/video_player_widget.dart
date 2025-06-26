import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget(this.videoUrl, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerPlusController controller;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    // Initialize video controller
    controller =
        CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(widget.videoUrl),
            httpHeaders: {
              // Optionally remove or update headers as needed
              'Connection': 'keep-alive',
            },
            invalidateCacheIfOlderThan: const Duration(days: 10),
          )
          ..initialize()
              .then((_) async {
                if (mounted) {
                  await controller.play();
                  await controller.setLooping(true);
                  setState(() {});
                }
              })
              .catchError((error) {
                // Catch and log errors during initialization
                setState(() {
                  isError = true;
                });
                print('Video initialization error: $error');
              });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Toggle play/pause
  // void playPause() {
  //   setState(() {
  //     if (controller.value.isPlaying) {
  //       controller.pause();
  //     } else {
  //       controller.play();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isError
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Center(child: const Text('Error loading video')),
            )
          : controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CachedVideoPlayerPlus(controller),
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
