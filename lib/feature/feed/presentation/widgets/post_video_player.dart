import 'dart:io';

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
  VideoPlayerController? _controller;
  bool _isInit = false;
  bool _failed = false;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  Future<void> _createController() async {
    try {
      // Phase 3: locally picked reels/videos arrive as file paths, remote ones
      // as http(s) URLs.
      final isRemote = widget.videoUrl.startsWith('http');
      final controller = isRemote
          ? VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          : VideoPlayerController.file(File(widget.videoUrl));
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _isInit = true;
      });
      controller.setLooping(true);
      controller.setVolume(0);
    } catch (_) {
      // No platform backend (e.g. Linux desktop) or a bad URL: show a
      // placeholder instead of crashing the widget tree.
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _playPause(bool visible) {
    final controller = _controller;
    if (!_isInit || controller == null) return;
    if (visible) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.ondemand_video, color: Colors.white54, size: 40),
        ),
      );
    }
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        final visiblePercentage = info.visibleFraction * 100;

        // play only if at least 70% visible
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
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
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