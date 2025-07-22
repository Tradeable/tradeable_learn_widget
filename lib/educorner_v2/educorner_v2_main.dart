import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_learn_widget/edu_cornerv1/edu_corner_model.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/educorner_v2/full_screen_image_viewer.dart';
import 'package:tradeable_learn_widget/utils/widget_bottom_container.dart';

class EduCornerV2Main extends StatefulWidget {
  final EduCornerModel model;
  final VoidCallback onNextClick;
  final VoidCallback onMenuClick;

  const EduCornerV2Main(
      {super.key,
      required this.model,
      required this.onNextClick,
      required this.onMenuClick});

  @override
  State<StatefulWidget> createState() => _EduCornerV2Main();
}

class _EduCornerV2Main extends State<EduCornerV2Main> {
  late final PageController controller;
  int currentPage = 0;
  List<EduCornerContent> items = [];

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.8);
    items = widget.model.cards;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          renderCards(constraints),
          const SizedBox(height: 24),
          renderContentSection(constraints),
          const Spacer(),
          renderNextButton()
        ],
      );
    });
  }

  Widget renderCards(BoxConstraints constraints) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Column(
      children: [
        SizedBox(
          height: constraints.maxHeight * 0.5,
          // fixed, large enough for tallest image
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              final imageUrl = items[index].imgUrl ?? "";
              final isCurrent = index == currentPage;
              return renderItem(constraints, imageUrl, isCurrent);
            },
          ),
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 24),
        SmoothPageIndicator(
          controller: controller,
          count: items.length,
          effect: CustomizableEffect(
            dotDecoration: DotDecoration(
              width: 7,
              height: 7,
              color: colors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            activeDotDecoration: DotDecoration(
              width: 16,
              height: 7,
              color: colors.borderColorPrimary,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget renderItem(
      BoxConstraints constraints, String imageUrl, bool isCurrent) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Transform.scale(
          scale: isCurrent ? 1 : 0.9,
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.transparent,
                  builder: (context) => FullScreenImageViewer(
                    imageUrl: imageUrl,
                    heroTag: 'image_$imageUrl',
                    imageUrls: items
                        .map((item) => item.imgUrl ?? "")
                        .where((url) => url.isNotEmpty)
                        .toList(),
                    initialIndex: currentPage,
                  ),
                );
              },
              child: Hero(
                tag: 'image_$imageUrl',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: isCurrent
                        ? constraints.maxHeight * 0.45
                        : constraints.maxHeight * 0.34,
                    child: Image.network(
                      imageUrl,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderContentSection(BoxConstraints constraints) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(items[currentPage].textContent?.title ?? "",
              maxLines: 1, style: textStyles.smallBold),
          AutoSizeText(items[currentPage].textContent?.content ?? "",
              maxFontSize: 14, minFontSize: 10, style: textStyles.smallNormal),
        ],
      ),
    );
  }

  Widget renderNextButton() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return WidgetBottomContainer(
      onMenuClick: () => widget.onMenuClick(),
      buttonWidget: ButtonWidget(
        color: colors.primary,
        btnContent: "Next",
        onTap: () {
          if (currentPage == items.length - 1) {
            widget.onNextClick();
          } else {
            controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        },
      ),
    );
  }
}
