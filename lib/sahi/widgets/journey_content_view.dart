import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/sahi/content/journey_content.dart';
import 'package:tradeable_learn_widget/sahi/widgets/concept_video.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_image_viewer.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

/// Renders the lesson content blocks, in order.
class JourneyContentView extends StatelessWidget {
  final List<JourneyContentItem> items;
  final VoidCallback onVideoTap;
  final VoidCallback onInfographicSwipe;

  const JourneyContentView({
    super.key,
    required this.items,
    required this.onVideoTap,
    required this.onInfographicSwipe,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyChapter();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          if (item.hasMedia)
            _ContentBlock(
              item: item,
              onVideoTap: onVideoTap,
              onInfographicSwipe: onInfographicSwipe,
            ),
      ],
    );
  }
}

class _ContentBlock extends StatelessWidget {
  final JourneyContentItem item;
  final VoidCallback onVideoTap;
  final VoidCallback onInfographicSwipe;

  const _ContentBlock({
    required this.item,
    required this.onVideoTap,
    required this.onInfographicSwipe,
  });

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case JourneyContentType.video:
        return _VideoBlock(item: item, onTap: onVideoTap);
      case JourneyContentType.infographic:
        return _InfographicBlock(
          item: item,
          onSwipe: onInfographicSwipe,
        );
      case JourneyContentType.blog:
        return _BlogBlock(item: item);
      case JourneyContentType.markdownText:
        return _MarkdownBlock(item: item);
      case JourneyContentType.recipe:
        return const SizedBox.shrink();
      case JourneyContentType.widget:
        return const SizedBox.shrink();
    }
  }
}

class _VideoBlock extends StatelessWidget {
  final JourneyContentItem item;
  final VoidCallback onTap;

  const _VideoBlock({required this.item, required this.onTap});

  // onTap unlocks the journey before handing off to the video.

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final thumbnail = item.thumbnail;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
            final url = item.url;
            if (url != null && url.isNotEmpty) launchVideoUrl(url);
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.sahiCardBorderColor),
              gradient: LinearGradient(
                colors: [
                  colors.sahiGradientPrimaryStart,
                  colors.sahiGradientPrimaryEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      thumbnail,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const SizedBox.shrink(),
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                Center(
                  child: Container(
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
                ),
                if (item.title != null)
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: Text(
                      item.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfographicBlock extends StatefulWidget {
  final JourneyContentItem item;
  final VoidCallback onSwipe;

  const _InfographicBlock({required this.item, required this.onSwipe});

  @override
  State<_InfographicBlock> createState() => _InfographicBlockState();
}

class _InfographicBlockState extends State<_InfographicBlock> {
  /// width / height of each image, keyed by path, so the carousel can be as tall
  /// as the tallest image instead of cropping everything to one fixed height.
  final Map<String, double> _ratios = {};
  final PageController _controller = PageController();
  int _index = 0;

  static const _minHeight = 200.0;
  static const _maxHeight = 420.0;

  @override
  void initState() {
    super.initState();
    _loadRatios();
  }

  @override
  void didUpdateWidget(covariant _InfographicBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.item, widget.item)) _loadRatios();
  }

  Future<void> _loadRatios() async {
    for (final image in widget.item.images) {
      if (_ratios.containsKey(image.image)) continue;
      final ratio = await _measure(image.image);
      if (!mounted) return;
      if (ratio == null) continue;
      setState(() => _ratios[image.image] = ratio);
    }
  }

  /// Reads the natural size off an asset. Network images keep the fallback
  /// ratio until they are measured by the layout.
  Future<double?> _measure(String source) async {
    if (source.startsWith('http')) return null;
    try {
      final data = await rootBundle.load(source);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final ratio = frame.image.width / frame.image.height;
      frame.image.dispose();
      codec.dispose();
      return ratio > 0 ? ratio : null;
    } catch (_) {
      return null;
    }
  }

  double _heightFor(double width) {
    final ratios = widget.item.images
        .map((image) => _ratios[image.image])
        .whereType<double>()
        .toList();
    if (ratios.isEmpty) return _minHeight;
    final shortest = ratios.reduce(math.min);
    return (width / shortest).clamp(_minHeight, _maxHeight);
  }

  void _openFullscreen(int index) {
    showJourneyImageViewer(context, widget.item.images, initialIndex: index);
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
    final images = widget.item.images;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: _heightFor(constraints.maxWidth),
              child: PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() => _index = index);
                  // Moving through the carousel counts as engaging.
                  widget.onSwipe();
                },
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    index == images.length - 1 ? 0 : 8,
                    0,
                  ),
                  child: _InfographicCard(
                    image: images[index],
                    fallbackTitle: widget.item.title,
                    fallbackCaption: widget.item.caption,
                    onTap: () => _openFullscreen(index),
                  ),
                ),
              ),
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final active = index == _index;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? colors.sahiGradientPrimaryStart
                          : colors.sahiTabBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfographicCard extends StatelessWidget {
  final JourneyContentImage image;
  final String? fallbackTitle;
  final String? fallbackCaption;
  final VoidCallback onTap;

  const _InfographicCard({
    required this.image,
    required this.onTap,
    this.fallbackTitle,
    this.fallbackCaption,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final isNetwork = image.image.startsWith('http');
    final title = image.title ?? fallbackTitle;
    final caption = image.caption ?? fallbackCaption;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: colors.sahiUtilityBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.sahiCardBorderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: isNetwork
                      ? Image.network(
                          image.image,
                          fit: BoxFit.contain,
                          errorBuilder: _imageFallback,
                        )
                      : Image.asset(
                          image.image,
                          fit: BoxFit.contain,
                          errorBuilder: _imageFallback,
                        ),
                ),
                if (title != null || caption != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 22, 12, 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          if (caption != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    return Container(
      color: colors.sahiTabBorder,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 22,
        color: colors.secondary,
      ),
    );
  }
}

class _BlogBlock extends StatelessWidget {
  final JourneyContentItem item;

  const _BlogBlock({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final url = item.url ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (url.isNotEmpty) launchExternalUrl(url);
          },
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.sahiUtilityBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.sahiCardBorderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.sahiGradientPrimaryStart.withAlpha(38),
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    size: 17,
                    color: colors.sahiGradientPrimaryStart,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? 'Read more',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.sahiPrimaryTextColor,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 15,
                  color: colors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkdownBlock extends StatelessWidget {
  final JourneyContentItem item;

  const _MarkdownBlock({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: MarkdownWidget(
        data: item.markdown ?? '',
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        config: tooltipMarkdownConfig(colors.sahiPrimaryTextColor),
      ),
    );
  }
}

class _EmptyChapter extends StatelessWidget {
  const _EmptyChapter();

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Text(
        "No content has been added to this chapter yet.",
        style: TextStyle(fontSize: 12, color: colors.secondary),
      ),
    );
  }
}
