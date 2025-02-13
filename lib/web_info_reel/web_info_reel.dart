import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/web_info_reel/webpage_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

// // Import for Android features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';

// // Import for iOS features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebInfoReel extends StatefulWidget {
  final WebpageModel model;
  final VoidCallback onNextClick;

  const WebInfoReel(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<WebInfoReel> createState() => _WebInfoReelState();
}

class _WebInfoReelState extends State<WebInfoReel> {
  late WebpageModel model;
  late WebViewController controller;
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    model = widget.model;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);
    controller.loadRequest(Uri.parse(model.url));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 70),
            child: WebViewWidget(controller: controller),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: "Next",
                onTap: () {
                  widget.onNextClick();
                }),
          ),
        ),
      ],
    );
  }
}
