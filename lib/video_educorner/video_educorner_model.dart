class VideoEduCornerModel {
  late String videoId;
  late String helperText;

  VideoEduCornerModel.fromJson(dynamic data) {
    videoId = data["video_id"];
    helperText = data["helperText"] ?? "";
  }
}
