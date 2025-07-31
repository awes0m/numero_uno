// Only imported on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'result_overview_platform.dart';

class ResultOverviewPlatformWeb implements ResultOverviewPlatform {
  @override
  Future<void> downloadImageWeb(List<int> imageBytes) async {
    final blob = html.Blob([imageBytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'numerology_result.png'
      ..style.display = 'none';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}

final ResultOverviewPlatform resultOverviewPlatform = ResultOverviewPlatformWeb();
