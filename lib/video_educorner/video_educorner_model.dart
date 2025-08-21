class VideoEduCornerModel {
  late String videoId;
  late String helperText;
  late String title;
  late String description;

  VideoEduCornerModel.fromJson(dynamic data) {
    videoId = data["video_id"];
    helperText = data["helperText"] ?? "";
    title = data["title"] ?? "";
    description = data["description"] ?? "";
  }
}
