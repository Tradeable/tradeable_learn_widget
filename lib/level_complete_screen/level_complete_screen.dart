import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/level_complete_screen/recommendation_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LevelCompleteScreen extends StatelessWidget {
  final Recommendations? recommendations;
  final String? comingFrom;

  const LevelCompleteScreen({super.key, this.recommendations, this.comingFrom});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      children: [
        const SizedBox(height: 30),
        Image.asset(
          "assets/level_complete.png",
          package: 'tradeable_learn_widget/lib',
          height: 160,
        ),
        const SizedBox(height: 20),
        Text("Options Champ",
            style: textStyles.mediumBold.copyWith(fontSize: 20)),
        const SizedBox(height: 5),
        Text("You've mastered the basics of options trading",
            style: textStyles.smallNormal, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        if (recommendations != null &&
            recommendations!.recommendations.isNotEmpty)
          ...recommendations!.recommendations.map((recommendation) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: colors.borderColorSecondary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Image.network(
                    recommendation.imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    recommendation.title,
                    style: textStyles.mediumBold.copyWith(fontSize: 16),
                  ),
                  subtitle: Text("Master options moneyness concepts",
                      style: textStyles.smallNormal
                          .copyWith(color: const Color(0xff6E6E6E))),
                  onTap: () {},
                ),
              )),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: colors.primary, btnContent: 'Next', onTap: () {})),
      ],
    );
  }
}
