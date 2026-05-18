import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parent_user.dart';
import '../models/child_profile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── ParentUser Operations ───────────────────────────────────────

  Future<void> createParentUser(ParentUser user) async {
    await _db.collection('parents').doc(user.id).set(user.toMap());
  }

  Future<ParentUser?> getParentUser(String id) async {
    final doc = await _db.collection('parents').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return ParentUser.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> markSurveyCompleted(String parentId) async {
    await _db.collection('parents').doc(parentId).set({
      'hasCompletedSurvey': true,
    }, SetOptions(merge: true));
  }

  // ── ChildProfile Operations ─────────────────────────────────────

  Future<void> addChildProfile(String parentId, ChildProfile child) async {
    final docRef = _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(child.id);
    await docRef.set(child.toMap());

    await _db.collection('parents').doc(parentId).set({
      'childProfileIds': FieldValue.arrayUnion([child.id])
    }, SetOptions(merge: true));
  }

  /// Fetch all child profiles for a parent.
  Future<List<ChildProfile>> getChildProfiles(String parentId) async {
    final snapshot = await _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .get();

    return snapshot.docs
        .map((doc) => ChildProfile.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Fetch a single child profile by ID.
  Future<ChildProfile?> getChildProfile(String parentId, String childId) async {
    final doc = await _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(childId)
        .get();

    if (doc.exists && doc.data() != null) {
      return ChildProfile.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  /// Update a child profile (e.g. after editing name or age).
  Future<void> updateChildProfile(String parentId, ChildProfile child) async {
    await _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(child.id)
        .set(child.toMap(), SetOptions(merge: true));
  }
}
