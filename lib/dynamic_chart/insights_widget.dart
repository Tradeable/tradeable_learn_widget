import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/info_container_bg.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class InsightsWidget extends StatelessWidget {
  final ShowInsightsPageTask insightsTask;

  const InsightsWidget({super.key, required this.insightsTask});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return InfoContainerBg(
        child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(insightsTask.title, style: textStyles.mediumBold),
          const SizedBox(height: 16),
          Text(insightsTask.description),
        ],
      ),
    ));
  }
}
