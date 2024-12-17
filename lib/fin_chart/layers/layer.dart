abstract class Layer {
  final String id;
  bool isSelected;

  Layer({required this.id, required this.isSelected});

  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1});

  void onChange(double pos, double value,
      {double hError = 1, double vError = 1});
}
