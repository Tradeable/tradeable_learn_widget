import 'package:flutter/widgets.dart';
import 'package:tradeable_learn_widget/demo_widget/demo_widget_model.dart';

class DemoWidget extends StatefulWidget {
  final DemoWidgetModel demoWidgetModel;
  const DemoWidget({super.key, required this.demoWidgetModel});

  @override
  State<DemoWidget> createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
