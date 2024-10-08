class VideoEduCornerModel {
  final dynamic data;
  late String videoId;
  late String helperText;

  VideoEduCornerModel(this.data) {
    videoId = data["video_id"];
    helperText = data["helperText"] ?? "";
  }
}
