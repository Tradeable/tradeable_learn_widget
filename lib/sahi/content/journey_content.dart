/// Content blocks a lesson is built from.
///
/// A lesson arrives as a list of widgets, each one a `model_type` string plus
/// a free-form `data` payload. Four types are supported today:
///
/// ```json
/// {"model_type": "video",         "data": {"url": "...", "title": "..."}}
/// {"model_type": "infographic",   "data": {"image": "assets/bull.png", "caption": "..."}}
/// {"model_type": "blog",          "data": {"title": "...", "url": "..."}}
/// {"model_type": "markdown_text", "data": {"content": "## Heading"}}
/// {"model_type": "recipe",        "data": {"recipe": {...}}}
/// ```
///
/// `recipe` is not rendered as a content block: it marks the chapter as the
/// interactive journey itself, and carries the chart recipe json.
library;

enum JourneyContentType { video, infographic, blog, markdownText, recipe }

/// A single image inside an infographic block.
class JourneyContentImage {
  final String image;
  final String? title;
  final String? caption;

  const JourneyContentImage(this.image, {this.title, this.caption});
}

/// One renderable block inside a chapter.
class JourneyContentItem {
  final JourneyContentType type;
  final String? url;
  final String? title;
  final String? subtitle;
  final String? caption;
  final String? image;
  final String? markdown;
  final List<JourneyContentImage> images;
  final Map<String, dynamic>? data;

  const JourneyContentItem({
    required this.type,
    this.url,
    this.title,
    this.subtitle,
    this.caption,
    this.image,
    this.markdown,
    this.images = const [],
    this.data,
  });

  const JourneyContentItem.video({String? url, String? title, String? subtitle})
      : this(
          type: JourneyContentType.video,
          url: url,
          title: title,
          subtitle: subtitle,
        );

  const JourneyContentItem.infographic({
    List<JourneyContentImage> images = const [],
    String? title,
    String? caption,
  }) : this(
          type: JourneyContentType.infographic,
          title: title,
          caption: caption,
          images: images,
        );

  const JourneyContentItem.blog({
    String? url,
    String? title,
    String? subtitle,
  }) : this(
          type: JourneyContentType.blog,
          url: url,
          title: title,
          subtitle: subtitle,
        );

  const JourneyContentItem.markdown(String content)
      : this(type: JourneyContentType.markdownText, markdown: content);

  const JourneyContentItem.recipe(Map<String, dynamic> data)
      : this(type: JourneyContentType.recipe, data: data);

  bool get hasMedia =>
      (url != null && url!.isNotEmpty) ||
      (image != null && image!.isNotEmpty) ||
      images.isNotEmpty ||
      (markdown != null && markdown!.isNotEmpty);

  /// The YouTube preview image for a video block, when the url points at
  /// YouTube. `null` for any other host, so callers can fall back.
  String? get thumbnail {
    final videoId = youtubeVideoId(url);
    if (videoId == null) return null;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  /// Builds an item from a `model_type` string and its `data` payload.
  ///
  /// Returns `null` for unsupported types so callers can skip them instead of
  /// rendering an empty block.
  static List<JourneyContentItem> fromJson(String? modelType, dynamic data) {
    switch (modelType?.trim().toLowerCase()) {
      case 'video':
        return [
          JourneyContentItem.video(
            url: _string(data, const ['url', 'video_url', 'link']),
            title: _string(data, const ['title', 'name']),
            subtitle: _string(data, const ['subtitle', 'description']),
          ),
        ];
      case 'infographic':
        return _infographics(data);
      case 'blog':
        return [
          JourneyContentItem.blog(
            url: _string(data, const ['url', 'link']),
            title: _string(data, const ['title', 'name']),
            subtitle:
                _string(data, const ['subtitle', 'description', 'source']),
          ),
        ];
      case 'recipe':
        final recipe = _map(data);
        if (recipe == null) return const [];
        return [JourneyContentItem.recipe(recipe)];
      case 'markdown_text':
      case 'markdown':
        return [
          JourneyContentItem.markdown(
            _string(data, const ['content', 'markdown', 'text']) ?? '',
          ),
        ];
      default:
        return const [];
    }
  }

  /// An infographic is a single block holding an array of images, so it renders
  /// as one swipeable card rather than one card per image.
  static List<JourneyContentItem> _infographics(dynamic data) {
    final images = _list(data, const ['images', 'slides'])
        .map(
          (entry) => entry is String
              ? JourneyContentImage(entry)
              : JourneyContentImage(
                  _string(entry, const ['image', 'src', 'url', 'path']) ?? '',
                  title: _string(entry, const ['title', 'name']),
                  caption: _string(entry, const ['caption', 'description']),
                ),
        )
        .where((image) => image.image.isNotEmpty)
        .toList();

    final single = _string(data, const ['image', 'src', 'url', 'path']);
    if (images.isEmpty && single != null) {
      images.add(
        JourneyContentImage(
          single,
          title: _string(data, const ['title', 'name']),
          caption: _string(data, const ['caption', 'description']),
        ),
      );
    }

    return [
      JourneyContentItem.infographic(
        images: images,
        title: _string(data, const ['title', 'name']),
        caption: _string(data, const ['caption', 'description']),
      ),
    ];
  }
}

/// Parses a list of `{model_type, data}` widgets into renderable items.
///
/// Accepts the raw `FlowWidget` payload, ignoring entries whose `model_type`
/// is not one of the four supported types.
List<JourneyContentItem> parseJourneyWidgets(dynamic widgets) {
  if (widgets is! List) return const [];
  return widgets.expand((widget) {
    if (widget is JourneyContentItem) return [widget];
    if (widget is! Map) return const <JourneyContentItem>[];
    final modelType = _string(widget, const ['model_type', 'modelType']);
    return JourneyContentItem.fromJson(modelType, widget['data']);
  }).toList();
}

/// Extracts the video id from the YouTube url shapes we accept:
/// `youtu.be/<id>`, `youtube.com/watch?v=<id>`, `youtube.com/embed/<id>` and a
/// bare id. Returns `null` for anything else.
String? youtubeVideoId(String? url) {
  if (url == null || url.trim().isEmpty) return null;
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (host.endsWith('youtu.be')) {
    final id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    return _isVideoId(id) ? id : null;
  }
  if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
    final queryId = uri.queryParameters['v'];
    if (_isVideoId(queryId)) return queryId;
    final segments = uri.pathSegments;
    if (segments.length > 1 &&
        (segments.first == 'embed' || segments.first == 'shorts')) {
      final id = segments[1];
      if (_isVideoId(id)) return id;
    }
  }
  return _isVideoId(uri.pathSegments.isEmpty ? null : uri.pathSegments.last)
      ? uri.pathSegments.last
      : null;
}

bool _isVideoId(String? value) =>
    value != null &&
    value.length == 11 &&
    RegExp(r'^[\w-]{11}$').hasMatch(value);

String? _string(dynamic source, List<String> keys) {
  for (final key in keys) {
    final value = source is Map ? source[key] : null;
    if (value is String && value.trim().isNotEmpty) return value;
    if (value is num) return value.toString();
  }
  return null;
}

Map<String, dynamic>? _map(dynamic value) {
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

List<dynamic> _list(dynamic source, List<String> keys) {
  for (final key in keys) {
    final value = source is Map ? source[key] : null;
    if (value is List) return value;
  }
  return const [];
}
