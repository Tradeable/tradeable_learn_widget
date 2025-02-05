class ButtonData {
  String title;
  String action;

  ButtonData({required this.title, required this.action});

  factory ButtonData.fromJson(Map<String, dynamic> json) {
    return ButtonData(
      title: json['title'] ?? '',
      action: json['action'] ?? '',
    );
  }
}
