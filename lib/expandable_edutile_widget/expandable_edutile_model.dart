class ExpandableEduTileModel {
  late String shortInfo;
  late List<TileData> tiles;
  late String videoId;

  ExpandableEduTileModel.fromJson(dynamic data) {
    shortInfo = data["shortInfo"];
    tiles = (data["tiles"] as List).map((e) => TileData.fromJson(e)).toList();
    videoId = data["videoId"] ?? "";
  }
}

class TileData {
  late String title;
  late String subtitle;
  late String content;

  TileData.fromJson(Map<String, dynamic> json) {
    title = json["title"] ?? "";
    subtitle = json["subtitle"] ?? "";
    content = json["content"] ?? "";
  }
}
