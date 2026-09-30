import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? playerId;

  const PostVideoPlayer({super.key, required this.videoUrl, this.playerId});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInit = false;
  bool _failed = false;
  bool _isMuted = true;
  bool _initializing = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // P6-2: defer controller creation until first visible frame so
    // off-screen feed videos don't all initialize/decode at once.
    if (widget.videoUrl.isEmpty) {
      _failed = true;
    }
  }

  @override
  void didUpdateWidget(PostVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller?.dispose();
      _controller = null;
      _isInit = false;
      _failed = widget.videoUrl.isEmpty;
      _initializing = false;
      _initialized = false;
      // Re-init lazily on next visible frame (handled in onVisibilityChanged).
    }
  }

  Future<void> _createController() async {
    if (_initializing || _initialized) return;
    _initializing = true;
    _initialized = true;
    if (widget.videoUrl.isEmpty) {
      if (!mounted) return;
      setState(() => _failed = true);
      return;
    }
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
    // P6-2: keep the VisibilityDetector mounted even before init so the
    // first visible frame triggers lazy init; paused otherwise.
    return VisibilityDetector(
      key: ValueKey(
        'video_${widget.playerId ?? widget.videoUrl}_${identityHashCode(this)}',
      ),
      onVisibilityChanged: (info) {
        const threshold = 0.5;
        final visible = info.visibleFraction > threshold;
        if (visible && !_initialized && !_failed) {
          _createController().then((_) {
            if (mounted) _playPause(true);
          });
          return;
        }
        _playPause(visible);
      },
      child: RepaintBoundary(
        child: _buildPlayer(),
      ),
    );
  }

  Widget _buildPlayer() {
    if (_failed) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.ondemand_video, color: Colors.white54, size: 40),
        ),
      );
    }
    if (!_isInit || _controller == null) {
      return const SizedBox.expand(
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    final size = _controller!.value.size;
    if (size.width == 0 || size.height == 0) {
      return const SizedBox.expand(
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // mute/Unmute icon
        Positioned(
          bottom: 12,
          right: 12,
          child: IconButton(
            tooltip: _isMuted ? 'Unmute' : 'Mute',
            onPressed: _toggleMute,
            icon: Icon(
              _isMuted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}