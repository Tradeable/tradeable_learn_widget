import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderCards(constraints),
            const SizedBox(height: 20),
            renderContentSection(constraints),
            const Spacer(),
            renderNextButton()
          ],
        ),
      );
    });
  }

  Widget renderCards(BoxConstraints constraints) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.55,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.eduCornerV2ContainerBg1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
              height: constraints.maxHeight * 0.45,
              child: PageView.builder(
                controller: controller,
                itemCount: items.length,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) {
                  final imageUrl = items[index].imgUrl ?? "";
                  return renderItem(constraints, imageUrl);
                },
              )),
          items.length > 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.cardBasicBackground),
                            child:
                                const Icon(Icons.arrow_back_ios_new, size: 14)),
                        color: colors.borderColorPrimary,
                        onPressed: currentPage > 0
                            ? () => controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                )
                            : null,
                      ),
                      Expanded(
                        child: Text(items[currentPage].textContent?.title ?? "",
                            maxLines: 2,
                            style: textStyles.smallBold,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center),
                      ),
                      IconButton(
                        icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.cardBasicBackground),
                            child:
                                const Icon(Icons.arrow_forward_ios, size: 14)),
                        color: colors.borderColorPrimary,
                        onPressed: currentPage < items.length - 1
                            ? () => controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                )
                            : null,
                      )
                    ],
                  ),
                )
              : Text(items[currentPage].textContent?.title ?? "",
                  maxLines: 2,
                  style: textStyles.smallBold,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget renderItem(BoxConstraints constraints, String imageUrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: constraints.maxHeight * 0.5,
          width: double.infinity,
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
    );
  }

  Widget renderContentSection(BoxConstraints constraints) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Expanded(
      child: AutoSizeText(items[currentPage].textContent?.content ?? "",
          maxFontSize: 14, minFontSize: 10, style: textStyles.smallNormal),
    );
  }

  Widget renderNextButton() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ButtonWidget(
        color: currentPage == items.length - 1
            ? colors.primaryButtonColor
            : colors.secondary,
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
