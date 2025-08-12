import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/secondary_button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool showVideo = false;

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
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Column(
      children: [
        Expanded(
          child: widget.model.title.isEmpty || showVideo
              ? renderVideoMode()
              : renderPreviewMode(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ButtonWidget(
            color: colors.primary,
            btnContent: "Next",
            onTap: widget.onNextClick,
          ),
        ),
      ],
    );
  }

  Widget renderPreviewMode() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final thumbnailUrl =
        YoutubePlayer.getThumbnail(videoId: widget.model.videoId);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7, // major portion for image
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 3, // smaller portion for text + buttons
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.title, style: textStyles.mediumBold),
                  const SizedBox(height: 4),
                  Expanded(
                    child: AutoSizeText(
                      widget.model.description,
                      maxLines: 4,
                      minFontSize: 10,
                      maxFontSize: 14,
                      style: textStyles.smallNormal
                          .copyWith(color: colors.textColorSecondary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButtonWidget(
                          color: colors.buttonColor,
                          btnContent: "Watch here",
                          onTap: () {
                            setState(() {
                              showVideo = true;
                            });
                          },
                          textStyle: textStyles.smallBold
                              .copyWith(color: colors.primary, fontSize: 12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ButtonWidget(
                          color: colors.primary,
                          btnContent: "Watch on Youtube",
                          onTap: () async {
                            final url = Uri.parse(
                                "https://www.youtube.com/watch?v=${widget.model.videoId}");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          textStyle: textStyles.smallBold.copyWith(
                              color: colors.cardBasicBackground, fontSize: 12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderVideoMode() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 0.5,
            ),
            finishedPlaying
                ? IconButton(
                    onPressed: () {
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                      setState(() {
                        isPlay = true;
                      });
                    },
                    icon: const Icon(Icons.replay, size: 50),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
