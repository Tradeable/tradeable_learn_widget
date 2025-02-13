class TicketCouponModel {
  final String title;
  final List<TicketInfoModel> infoModel;
  final String color;

  TicketCouponModel(
      {required this.title, required this.infoModel, required this.color});

  factory TicketCouponModel.fromJson(Map<String, dynamic> json) {
    return TicketCouponModel(
      title: json["title"],
      infoModel: (json['infoModel'] as List<dynamic>)
          .map((rowItem) => TicketInfoModel.fromJson(rowItem))
          .toList(),
      color: json["color"] ?? "",
    );
  }
}

class TicketInfoModel {
  final String title;
  String? amount;
  String? subtext;

  TicketInfoModel({required this.title, this.amount, this.subtext});

  factory TicketInfoModel.fromJson(Map<String, dynamic> json) {
    return TicketInfoModel(
        title: json["title"], amount: json["amount"], subtext: json["subtext"]);
  }
}
