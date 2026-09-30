import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/content/journey_content.dart';
import 'package:tradeable_learn_widget/sahi/widgets/concept_video.dart';
import 'package:tradeable_learn_widget/sahi/widgets/continue_journey_button.dart';
import 'package:tradeable_learn_widget/sahi/widgets/course_progress_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_content_view.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_top_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/video_banner.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactChartView extends StatefulWidget {
  final double progress;
  final String? videoUrl;
  final VoidCallback onProceed;
  final List<JourneyItem> journeyItems;
  final List<JourneyContentItem> content;

  const SahiCompactChartView({
    super.key,
    required this.progress,
    required this.onProceed,
    required this.journeyItems,
    this.content = const [],
    this.videoUrl,
  });

  @override
  State<SahiCompactChartView> createState() => _SahiCompactChartViewState();
}

class _SahiCompactChartViewState extends State<SahiCompactChartView> {
  bool _contentUnlocked = false;

  /// A chapter that carries a recipe is the interactive journey itself, so the
  /// tabs and the journey call to action only make sense there.
  bool get _hasRecipe => widget.content.any(
        (item) => item.type == JourneyContentType.recipe,
      );

  void _unlock() {
    if (_contentUnlocked) return;
    setState(() => _contentUnlocked = true);
  }

  void _onPrimaryAction() {
    if (_hasRecipe) {
      widget.onProceed();
      return;
    }
    Navigator.of(context).pop();
  }

  /// Scrolling past the top of the page counts as engaging with the chapter.
  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels > 0) _unlock();
    return false;
  }

  void _onVideoTap() {
    _unlock();
    launchVideoUrl(widget.videoUrl ?? conceptVideoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final content = widget.content;

    return Scaffold(
      backgroundColor: colors.sahiMobileTabBarBg,
      appBar: JourneyTopBar(
        onBack: () => Navigator.of(context).pop(),
        onWatch: _onVideoTap,
        journeyItems: widget.journeyItems,
      ),
      body: Column(
        children: [
          CourseProgressBar(
            progress: widget.progress,
            height: 3,
            borderRadius: 0,
            progressBgColor: Colors.transparent,
          ),
          Container(height: 8, color: colors.sahiTabBg),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.isEmpty)
                      VideoBanner(
                        onTap: _onVideoTap,
                        image: const AssetImage('assets/bull.png'),
                        borderRadius: 0,
                        height: 200,
                        iconWidget: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.black,
                          ),
                        ),
                      )
                    else
                      JourneyContentView(
                        items: content,
                        onVideoTap: _onVideoTap,
                        onInfographicSwipe: _unlock,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ContinueJourneyButton(
        text: _hasRecipe ? "Go to Journey" : "Next Chapter",
        enabled: _contentUnlocked,
        onPressed: _onPrimaryAction,
        disabledIcon: Icons.lock_outline,
        disabledBackgroundColor: colors.sahiButtonDisabledBgColor,
        disabledTextColor: colors.secondary,
        startColor: colors.sahiGradientPrimaryStart,
        endColor: colors.sahiGradientPrimaryEnd,
      ),
    );
  }
}
