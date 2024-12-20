import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_learn_widget/ladder_widget/dotted_border_container.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class EduCornerV1 extends StatefulWidget {
  final EduCornerModel model;
  final VoidCallback onNextClick;

  const EduCornerV1(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<EduCornerV1> createState() => _EduCornerV1State();
}

class _EduCornerV1State extends State<EduCornerV1> {
  late EduCornerModel model;
  final PageController controller = PageController(initialPage: 0);
  double videoBtnHeight = 50;
  int currentPage = 0;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          renderTitle(model.title),
          const SizedBox(height: 30),
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 0.75,
            child: renderEduCornerCards(model.cards),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: model.cards.length,
              effect: WormEffect(
                dotHeight: 7,
                dotWidth: currentPage == model.cards.length - 1 ? 10 : 7,
                activeDotColor: colors.borderColorPrimary,
                type: WormType.thin,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
              color: currentPage == model.cards.length - 1
                  ? colors.primary
                  : colors.secondary,
              btnContent: "Next",
              onTap: () {
                if (currentPage == model.cards.length - 1) {
                  widget.onNextClick();
                }
              },
            ),
          )
        ],
      );
    });
  }

  Widget renderTitle(String title) {
    final textStyles = Theme.of(context).customTextStyles;

    return title.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(title, style: textStyles.largeBold),
          );
  }

  Widget renderEduCornerCards(List<EduCornerContent> cards) {
    return PageView(
      controller: controller,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      children: buildEduCornerCards(cards),
    );
  }

  List<Widget> buildEduCornerCards(List<EduCornerContent> cards) {
    List<Widget> builtCards = [];
    for (EduCornerContent card in cards) {
      switch (card.type) {
        case EduCornerContentType.imageAndText:
          builtCards.add(buildimageTextCard(card));
          break;
        case EduCornerContentType.onlyImage:
          builtCards.add(buildImageCard(card));
          break;
        case EduCornerContentType.onlyText:
          builtCards.add(Container());
          break;
      }
    }
    return builtCards;
  }

  Widget buildimageTextCard(EduCornerContent card) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.9,
            height: constraints.maxHeight * 0.6,
            child: DottedBorderWidget(
              backgroundColor: Colors.transparent,
              borderColor: colors.borderColorSecondary,
              child: Stack(children: [
                Container(
                  margin: EdgeInsets.only(bottom: videoBtnHeight / 2),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.network(card.imgUrl!, fit: BoxFit.fill),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: videoButton(card.videoId),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.cardColorSecondary,
                ),
                height: 40,
                child: IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
              Text(card.textContent?.title ?? "", style: textStyles.mediumBold),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.cardColorSecondary,
                ),
                height: 40,
                child: IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(card.textContent?.content ?? "",
                  minFontSize: 12, maxLines: 5),
            ),
          )
        ],
      );
    }));
  }

  Widget buildImageCard(EduCornerContent card) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: constraints.maxWidth,
              height: card.videoId != null
                  ? constraints.maxHeight * 0.8
                  : constraints.maxHeight,
              child: Image.network(card.imgUrl!)),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Align(
                alignment: Alignment.bottomRight,
                child: videoButton(card.videoId)),
          )
        ],
      );
    }));
  }

  Widget videoButton(String? videoId) {
    final colors = Theme.of(context).customColors;

    if (videoId == "" || videoId == null) {
      return Container();
    } else {
      return Container(
        height: videoBtnHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: colors.primary),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoEduCorner(
                        model:
                            VideoEduCornerModel.fromJson({"video_id": videoId}),
                        onNextClick: () {})));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Watch Video'),
        ),
      );
    }
  }
}
