abstract class ResultOverviewPlatform {
  Future<void> downloadImageWeb(List<int> imageBytes);
}

class ResultOverviewPlatformStub implements ResultOverviewPlatform {
  @override
  Future<void> downloadImageWeb(List<int> imageBytes) async {
    // No-op for non-web platforms
  }
}

final ResultOverviewPlatform resultOverviewPlatform = ResultOverviewPlatformStub();
