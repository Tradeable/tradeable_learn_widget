import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';

class ChartPointer extends Layer {
  double pos;
  double value;
  Function(ChartPointer)? onUpdate;

  ChartPointer(
      {required super.id,
      super.isSelected = false,
      this.pos = 0,
      this.value = 0,
      this.onUpdate});

  @override
  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if ((this.pos - pos).abs() < hError &&
        (this.value - value).abs() < vError) {
      return id;
    } else {
      return null;
    }
  }

  @override
  void onChange(double pos, double value,
      {double hError = 1, double vError = 1}) {
    this.pos = pos;
    this.value = value;
    if (onUpdate != null) {
      onUpdate!(this);
    }
  }
}
