class TableModel {
  final List<TableData>? tableData;
  final String? tableAlignment;
  final bool? isQuantitySquared;

  TableModel({this.tableData, this.tableAlignment, this.isQuantitySquared});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
        tableData: json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((tableItem) => TableData.fromJson(tableItem))
                .toList()
            : null,
        tableAlignment: json["tableAlignment"] ?? "",
        isQuantitySquared: json["isQuantitySquared"] ?? false);
  }
}

class TableData {
  String title;
  List<String> tableColors;
  List<RowData> data;
  String totalValue;

  TableData(
      {required this.title,
      required this.tableColors,
      required this.data,
      required this.totalValue});

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
        title: json['title'] ?? '',
        tableColors: (json['tableColors'] as List<dynamic>)
            .map((color) => color.toString())
            .toList(),
        data: (json['data'] as List<dynamic>)
            .map((rowItem) => RowData.fromJson(rowItem))
            .toList(),
        totalValue: json['totalValue']);
  }
}

class RowData {
  String price;
  String orders;
  String quantity;

  RowData({required this.price, required this.orders, required this.quantity});

  factory RowData.fromJson(Map<String, dynamic> json) {
    return RowData(
      price: json['price'] ?? '',
      orders: json['orders'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}
