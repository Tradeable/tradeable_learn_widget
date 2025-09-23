import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/info_container_bg.dart';

class InsightsWidget extends StatelessWidget {
  final ShowInsightsPageTask insightsTask;

  const InsightsWidget({super.key, required this.insightsTask});

  @override
  Widget build(BuildContext context) {
    return InfoContainerBg(
        child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          MarkdownWidget(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            data: insightsTask.title,
            config: MarkdownConfig(configs: [
              H1Config(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 16),
          MarkdownWidget(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              data: insightsTask.description),
        ],
      ),
    ));
  }
}
