import 'package:url_launcher/url_launcher.dart';

const conceptVideoUrl = "https://youtu.be/PMRDjhtW7j4";

Future<void> launchExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<void> launchVideoUrl(String url) => launchExternalUrl(url);

Future<void> launchConceptVideo() => launchVideoUrl(conceptVideoUrl);
