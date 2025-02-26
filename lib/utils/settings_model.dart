class SettingsModel {
  bool? showPnlAnimation;
  int? candleSpeed;
  bool? showPnlInfo;

  SettingsModel({this.showPnlAnimation, this.candleSpeed, this.showPnlInfo});

  SettingsModel.fromJson(dynamic data) {
    showPnlAnimation = data["showPnlAnimation"] ?? false;
    candleSpeed = data["candleSpeed"] ?? 50;
    showPnlInfo = data["showPnlInfo"] ?? false;
  }
}
