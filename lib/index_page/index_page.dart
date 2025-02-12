import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_learn_widget/index_page/index_page_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class IndexPage extends StatefulWidget {
  final IndexPageModel model;
  final VoidCallback onNextClick;

  const IndexPage({super.key, required this.model, required this.onNextClick});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late IndexPageModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.green.withAlpha(90),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(model.title,
                        textAlign: TextAlign.center,
                        style: textStyles.largeBold),
                    const SizedBox(height: 12),
                    Text(model.description,
                        textAlign: TextAlign.center,
                        style: textStyles.mediumBold),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Lottie.network(
                  model.image,
                  repeat: true,
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  model.intro,
                  textAlign: TextAlign.left,
                  style: textStyles.mediumBold,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, position) {
                        return Text(" - ${model.content[position]}",
                            textAlign: TextAlign.left,
                            style: textStyles.mediumNormal);
                      },
                      separatorBuilder: (context, position) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: model.content.length)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: "Next",
                onTap: () {
                  widget.onNextClick();
                }),
          ),
        ),
      ],
    );
  }
}
