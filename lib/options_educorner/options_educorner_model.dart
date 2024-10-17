class OptionsEduCornerModel {
  late String educornerType;
  late List<int> strikePrices;
  late List<double> callDelta;
  late List<double> callGamma;
  late List<double> callVega;
  late List<double> putDelta;
  late List<double> putGamma;
  late List<double> putVega;
  late List<double> vegaPremium;
  late List<int> carValues;
  late List<String> explanations;

  OptionsEduCornerModel.fromJson(dynamic data) {
    educornerType = data["educornerType"];
    strikePrices = data["strikePrices"].cast<int>() as List<int>;
    callDelta = data["callDelta"].cast<double>() as List<double>;
    callGamma = data["callGamma"].cast<double>() as List<double>;
    callVega = data["callVega"].cast<double>() as List<double>;
    putDelta = data["putDelta"].cast<double>() as List<double>;
    putGamma = data["putGamma"].cast<double>() as List<double>;
    putVega = data["putVega"].cast<double>() as List<double>;
    vegaPremium = data["vegaPremium"].cast<double>() as List<double>;
    carValues = data["carValues"].cast<int>() as List<int>;
    explanations = data["explanations"].cast<String>() as List<String>;
  }
}
