import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiOptionChainHeader extends StatelessWidget {
  final VoidCallback onViewChartClicked;
  final VoidCallback onSettingsClicked;
  final String expiry;

  const SahiOptionChainHeader(
      {super.key,
      required this.onViewChartClicked,
      required this.onSettingsClicked,
      required this.expiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              renderChartButtonContainer(context),
              renderTickerContainer(context),
              renderSettingsButtonContainer(context)
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const InfoTextContainer(
          //         text: "Call", isRightAligned: true, icon: Icons.arrow_left),
          //     InfoTextContainer(text: expiry, isRightAligned: false),
          //     const InfoTextContainer(
          //         text: "Put", isRightAligned: false, icon: Icons.arrow_right),
          //   ],
          // ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget renderChartButtonContainer(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            onViewChartClicked();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Icon(Icons.candlestick_chart_outlined,
                color: colors.optionChainChartIconColor, size: 22),
          ),
        ),
      ),
    );
  }

  Widget renderTickerContainer(BuildContext context) {
    // final colors =
    //     TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        // decoration: BoxDecoration(
        //     borderRadius: const BorderRadius.only(
        //         bottomLeft: Radius.circular(16),
        //         bottomRight: Radius.circular(16)),
        //     color: colors.optionChainTickerBg),
        child: Text("Nifty 50", style: textStyles.smallBold));
  }

  Widget renderSettingsButtonContainer(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            onSettingsClicked();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Image.asset(
              "assets/equalizer-line.png",
              package: 'tradeable_learn_widget/lib',
              height: 22,
            ),
          ),
        ),
      ),
    );
  }
}
