import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/content/journey_content.dart';
import 'package:tradeable_learn_widget/sahi/widgets/continue_journey_button.dart';
import 'package:tradeable_learn_widget/sahi/widgets/course_progress_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_content_view.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_top_bar.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactChartView extends StatefulWidget {
  final double progress;
  final String? videoUrl;
  final VoidCallback onProceed;
  final VoidCallback onPlayWidget;
  final List<JourneyItem> journeyItems;
  final List<JourneyContentItem> content;

  const SahiCompactChartView({
    super.key,
    required this.progress,
    required this.onProceed,
    required this.onPlayWidget,
    required this.journeyItems,
    this.content = const [],
    this.videoUrl,
  });

  @override
  State<SahiCompactChartView> createState() => _SahiCompactChartViewState();
}

class _SahiCompactChartViewState extends State<SahiCompactChartView> {
  bool _contentUnlocked = false;
  bool get _hasRecipe => widget.content.any(
        (item) => item.type == JourneyContentType.recipe,
      );
  bool get _hasPlayWidget => widget.content.any(
        (item) => item.type == JourneyContentType.widget,
      );

  String get _primaryActionText {
    if (_hasPlayWidget) return "Let's Play";
    return _hasRecipe ? "Go to Journey" : "Next Chapter";
  }

  void _unlock() {
    if (_contentUnlocked) return;
    setState(() => _contentUnlocked = true);
  }

  void _onPrimaryAction() {
    if (_hasPlayWidget) {
      widget.onPlayWidget();
      return;
    }
    if (_hasRecipe) {
      widget.onProceed();
      return;
    }
    Navigator.of(context).pop();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels > 0) _unlock();
    return false;
  }

  void _onContentVideoTap() => _unlock();

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final content = widget.content;

    return Scaffold(
      backgroundColor: colors.sahiMobileTabBarBg,
      appBar: JourneyTopBar(
        onBack: () => Navigator.of(context).pop(),
        journeyItems: widget.journeyItems,
        showJourney: _hasRecipe,
        showPlayIcon: _hasPlayWidget,
        playMuted: true,
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
                    JourneyContentView(
                      items: content,
                      onVideoTap: _onContentVideoTap,
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
        text: _primaryActionText,
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
