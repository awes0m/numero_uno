import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_router.dart';

List<Widget> commonIconButtons(BuildContext context) {
  return [
    IconButton(
      tooltip: 'About Yantras',
      icon: const Icon(Icons.auto_awesome_mosaic_outlined),
      onPressed: () {
        // Navigate to Yatras page
        AppNavigator.toYantras(context);
      },
    ),
    IconButton(
      tooltip: 'Download Android App',
      icon: const Icon(Icons.file_download_outlined),
      onPressed: () {
        // Link to download Android app
        launch('https://github.com/awes0m/numero_uno/tree/main/release');
      },
    ),
  ];
}
