import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

class TVPlayerPage extends StatefulWidget {
  final String url;

  TVPlayerPage(this.url);

  @override
  _TVPlayerPageState createState() => _TVPlayerPageState();
}

class _TVPlayerPageState extends State<TVPlayerPage> {
  VideoPlayerController _controller;
  bool showAppBar = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          Screen.keepOn(true);
          Timer(Duration(seconds: 3), () {
            setState(() {
              showAppBar = false;
            });
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _controller.value.initialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    if (!showAppBar) {
                      showAppBar = true;
                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          showAppBar = false;
                        });
                      });
                    } else {
                      showAppBar = false;
                    }
                  });
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(
                child: Center(
                  child: Container(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
