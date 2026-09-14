import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const PostVideoPlayer({super.key, required this.videoUrl});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late VideoPlayerController controller;
  bool _isInit = false;
  bool isMuted = true;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInit = true;
        });
        controller.setLooping(true);
        controller.setVolume(0);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      child: _isInit
          ? Stack(children: [
            SizedBox.expand(
              child: FittedBox(

              ),
            )
      ],)
          : Center(child: CircularProgressIndicator(color: Colors.white)),
      onVisibilityChanged: (info) {},
    );
  }
}
