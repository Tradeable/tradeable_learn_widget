class MarketDepthUserStory {
  String id;
  String name;
  String description;
  List<StepData> steps;

  MarketDepthUserStory({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
  });

  factory MarketDepthUserStory.fromJson(Map<String, dynamic> json) {
    return MarketDepthUserStory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      steps: (json['steps'] as List<dynamic>)
          .map((step) => StepData.fromJson(step))
          .toList(),
    );
  }
}

class StepData {
  String stepId;
  List<UiData> ui;

  StepData({required this.stepId, required this.ui});

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      stepId: json['stepId'] ?? '',
      ui: (json['ui'] as List<dynamic>)
          .map((uiItem) => UiData.fromJson(uiItem))
          .toList(),
    );
  }
}

class UiData {
  String widget;
  String title;
  String prompt;
  String? tableAlignment;
  List<TableData>? tableData;
  String? buttonsFormat;
  List<ButtonData>? buttonsData;
  String? format;
  List<String>? options;
  List<String>? correctResponse;
  String? action;

  UiData(
      {required this.widget,
      required this.title,
      required this.prompt,
      this.tableAlignment,
      this.tableData,
      this.buttonsFormat,
      this.buttonsData,
      this.format,
      this.options,
      this.correctResponse,
      this.action});

  factory UiData.fromJson(Map<String, dynamic> json) {
    return UiData(
        widget: json['widget'] ?? '',
        title: json['title'] ?? '',
        prompt: json['prompt'] ?? '',
        tableAlignment: json['tableAlignment'],
        tableData: json['tableData'] != null
            ? (json['tableData'] as List<dynamic>)
                .map((tableItem) => TableData.fromJson(tableItem))
                .toList()
            : null,
        buttonsFormat: json['buttonsFormat'],
        buttonsData: json['buttonsData'] != null
            ? (json['buttonsData'] as List<dynamic>)
                .map((buttonItem) => ButtonData.fromJson(buttonItem))
                .toList()
            : null,
        format: json['format'],
        options:
            json['options'] != null ? List<String>.from(json['options']) : null,
        correctResponse: json['correctResponse'] != null
            ? List<String>.from(json['correctResponse'])
            : null,
        action: json['action'] ?? '');
  }
}

class TableData {
  String title;
  List<String> tableColors;
  List<RowData> data;
  String totalValue;

  TableData({
    required this.title,
    required this.tableColors,
    required this.data,
    required this.totalValue,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      title: json['title'] ?? '',
      tableColors: (json['tableColors'] as List<dynamic>)
          .map((color) => color.toString())
          .toList(),
      data: (json['data'] as List<dynamic>)
          .map((rowItem) => RowData.fromJson(rowItem))
          .toList(),
      totalValue: json['totalValue'],
    );
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
