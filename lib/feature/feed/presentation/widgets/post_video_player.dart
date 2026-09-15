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
  bool _isMuted = true;

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

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _playPause(bool visible) {
    if (!_isInit) return;
    if (visible) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        final visiblePercentage = info.visibleFraction * 100;

        // play only if al least 70% only
        if (visiblePercentage > 70) {
          _playPause(true);
        } else {
          _playPause(false);
        }
      },
      child: _isInit
          ? Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                // mute/Unmute icon
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(),
                      child: Icon(
                        _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
