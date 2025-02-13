import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/banana_widget/banana_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BananaWidget extends StatefulWidget {
  final BananaModel model;
  final VoidCallback onNextClick;

  const BananaWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<BananaWidget> createState() => _BananaWidgetState();
}

class _BananaWidgetState extends State<BananaWidget> {
  late BananaModel model;
  double sliderValue = 20;
  int initialIndex = 1;
  List<String> labels = [
    "Days to expiry : 5 | Price : 50",
    "Days to expiry : 4 | Price : 40",
    "Days to expiry : 3 | Price : 30",
    "Days to expiry : 2 | Price : 20",
    "Days to expiry : 1 | Price : 10"
  ];

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Column(
            children: <Widget>[
              MarkdownBody(
                data: model.content1,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        h3: textStyles.largeBold.copyWith(fontSize: 28),
                        strong: textStyles.mediumBold,
                        p: textStyles.mediumNormal),
              ),
              const SizedBox(height: 20),
              model.isSliderToBeShown
                  ? Slider(
                      value: sliderValue,
                      onChanged: (value) {
                        setState(() {
                          initialIndex = (value ~/ (100 / labels.length))
                              .clamp(0, labels.length - 1);
                          sliderValue = value;
                        });
                      },
                      min: 0.0,
                      max: 100.0,
                      divisions: 4,
                      label: labels[initialIndex],
                    )
                  : Container(),
              MarkdownBody(
                data: model.content2,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        h3: textStyles.largeBold.copyWith(fontSize: 28),
                        strong: textStyles.mediumBold,
                        p: textStyles.mediumNormal),
              ),
              BananaInfographic(
                infographic: model.infographic,
                helperText: model.helperText,
              ),
              const SizedBox(height: 20),
              MarkdownBody(
                data: model.content3,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        h3: textStyles.largeBold.copyWith(fontSize: 28),
                        strong: textStyles.mediumBold,
                        p: textStyles.mediumNormal),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ],
      ),
    );
  }
}

class BananaInfographic extends StatefulWidget {
  final Infographic infographic;
  final List<String> helperText;

  const BananaInfographic(
      {super.key, required this.infographic, required this.helperText});

  @override
  State<StatefulWidget> createState() => _BananaInfographicState();
}

class _BananaInfographicState extends State<BananaInfographic> {
  CarouselController carouselController = CarouselController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: Column(
        children: [
          CarouselSlider(
              items: LoadImagesService().getImages(widget.infographic),
              options: CarouselOptions(
                  aspectRatio: 1 / 1,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           carouselController.previousPage(
          //             duration: const Duration(milliseconds: 300),
          //           );
          //           index != 0 ? index-- : 0;
          //           // carouselController.
          //           index != 0 ? index-- : 0;
          //         });
          //       },
          //       child: const Icon(
          //         Icons.arrow_back_ios_outlined,
          //         size: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //     Text(
          //       widget.helperText[index],
          //       style: const TextStyle(fontSize: 12),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           carouselController.nextPage(
          //             duration: const Duration(milliseconds: 300),
          //           );
          //           index != widget.helperText.length - 1
          //               ? index++
          //               : widget.helperText.length - 1;
          //         });
          //       },
          //       child: const Icon(
          //         Icons.arrow_forward_ios,
          //         size: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

class LoadImagesService {
  List<Widget> getImages(Infographic dataItem) {
    List<Widget> images = [];
    for (String url in dataItem.imageUrls!) {
      images.add(Image.network(
        url,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ));
    }
    return images;
  }
}
