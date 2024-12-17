import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoEduCorner extends StatefulWidget {
  final VideoEduCornerModel model;
  final VoidCallback onNextClick;

  const VideoEduCorner(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<VideoEduCorner> createState() => _VideoEduCorner();
}

class _VideoEduCorner extends State<VideoEduCorner> {
  late YoutubePlayerController _controller;
  Duration? videoDuration;
  bool isPlay = false;
  bool finishedPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.model.videoId,
      flags: const YoutubePlayerFlags(
          captionLanguage: "en",
          enableCaption: true,
          autoPlay: true,
          mute: false,
          hideControls: false),
    );
    _controller.addListener(() {
      if (_controller.value.isReady && _controller.value.isPlaying) {
        setState(() {
          videoDuration = _controller.metadata.duration;
        });
      }
      if (videoDuration != null &&
          videoDuration!.inSeconds != 0 &&
          _controller.value.position.inSeconds == videoDuration!.inSeconds) {
        setState(() {
          isPlay = false;
          finishedPlaying = true;
        });
      } else {
        setState(() {
          finishedPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              YoutubePlayer(
                aspectRatio: 0.64,
                controller: _controller,
              ),
              finishedPlaying
                  ? Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          if (finishedPlaying) {
                            _controller.seekTo(Duration.zero);
                            _controller.play();
                          }
                          if (isPlay) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                          setState(() {
                            isPlay = !isPlay;
                          });
                        },
                        icon: const Icon(
                          Icons.replay,
                          size: 50,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: "Next",
                onTap: () {
                  widget.onNextClick();
                })),
      ],
    );
  }
}
