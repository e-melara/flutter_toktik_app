import 'package:flutter/material.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';

import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;

  const FullscreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
  });

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.videoUrl)
      ..setVolume(0)
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
          );
        }

        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: GestureDetector(
              onTap: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                  return;
                }
                controller.play();
              },
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: Stack(
                  children: [VideoPlayer(controller), VideoBackground()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
