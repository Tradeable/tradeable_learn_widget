import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/axis_settings.dart';

enum XAxisPos { top, bottom }

class XAxisSettings extends AxisSettings {
  final XAxisPos xAxisPos;

  const XAxisSettings(
      {super.axisTextStyle,
      super.axisColor,
      super.strokeWidth,
      this.xAxisPos = XAxisPos.bottom});
}
