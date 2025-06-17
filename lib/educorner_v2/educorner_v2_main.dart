import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_learn_widget/edu_cornerv1/edu_corner_model.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/educorner_v2/full_screen_image_viewer.dart';

class EduCornerV2Main extends StatefulWidget {
  final EduCornerModel model;
  final VoidCallback onNextClick;

  const EduCornerV2Main(
      {super.key, required this.model, required this.onNextClick});

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
          renderCards(constraints),
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

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.65,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.eduCornerV2ContainerBg1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.eduCornerV2ContainerBg2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(
                height: constraints.maxHeight * 0.55,
                child: PageView.builder(
                  controller: controller,
                  itemCount: items.length,
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemBuilder: (context, index) {
                    final imageUrl = items[index].imgUrl ?? "";
                    return renderItem(constraints, imageUrl);
                  },
                )),
            const SizedBox(height: 20),
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
        ),
      ),
    );
  }

  Widget renderItem(BoxConstraints constraints, String imageUrl) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: constraints.maxHeight * 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: colors.eduCornerV2ContainerBg1,
          ),
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: colors.eduCornerImageBg,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: colors.borderColorSecondary,
                  blurRadius: 4,
                  offset: const Offset(1, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
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
    );
  }

  Widget renderContentSection(BoxConstraints constraints) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      height: constraints.maxHeight * 0.2,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colors.eduCornerV2ContainerBg1,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.eduCornerImageBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.borderColorSecondary,
              blurRadius: 4,
              offset: const Offset(1, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(items[currentPage].textContent?.title ?? "",
                maxLines: 1,
                style: textStyles.smallNormal
                    .copyWith(color: colors.textColorSecondary)),
            Expanded(
              child: AutoSizeText(items[currentPage].textContent?.content ?? "",
                  maxFontSize: 14,
                  minFontSize: 10,
                  style: textStyles.smallNormal),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderNextButton() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: ButtonWidget(
        color:
            currentPage == items.length - 1 ? colors.primary : colors.secondary,
        btnContent: "Next",
        onTap: () {
          if (currentPage == items.length - 1) {
            widget.onNextClick();
            // showModalBottomSheet(
            //   isDismissible: false,
            //   context: context,
            //   builder: (context) =>
            //       InfoBottomSheet(onNextClick: widget.onNextClick),
            // );
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
