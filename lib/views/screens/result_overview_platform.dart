import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


Future<void> downloadImageMobile(
  List<int> imageBytes,
  BuildContext context,
) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath =
      '${directory.path}/numerology_result_${DateTime.now().millisecondsSinceEpoch}.png';
  final file = File(imagePath);
  await file.writeAsBytes(imageBytes);

  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Image saved to $imagePath')));
  }
}
