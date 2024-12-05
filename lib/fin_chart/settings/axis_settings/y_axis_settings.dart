import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/axis_settings.dart';

enum YAxisPos { left, right }

class YAxisSettings extends AxisSettings {
  final YAxisPos yAxisPos;

  const YAxisSettings(
      {super.axisTextStyle,
      super.axisColor,
      super.strokeWidth,
      this.yAxisPos = YAxisPos.left});
}
