import 'package:cloud_firestore/cloud_firestore.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _docId = 'viewCount';

  Future<void> incrementViewerCount() {
    final doc = _firestore.collection('stats').doc(_docId);
    return doc.set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Stream<int> viewerCountStream() {
    return _firestore
        .collection('stats')
        .doc(_docId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['count'] as int? ?? 0);
  }
}
