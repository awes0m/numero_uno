// Web implementation for downloading image using package:web
import 'package:web/web.dart' as web;

void downloadImage(String dataUrl, String filename) {
  final anchor = web.HTMLAnchorElement()
    ..href = dataUrl
    ..download = filename
    ..style.display = 'none';
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
