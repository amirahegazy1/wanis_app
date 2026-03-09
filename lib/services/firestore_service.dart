import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parent_user.dart';
import '../models/child_profile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ParentUser Operations
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

  // ChildProfile Operations
  Future<void> addChildProfile(String parentId, ChildProfile child) async {
    final docRef = _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(child.id);
    await docRef.set(child.toMap());

    // Assuming you want to add this child's id to the parent's record as well
    await _db.collection('parents').doc(parentId).update({
      'childProfileIds': FieldValue.arrayUnion([child.id])
    });
  }

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

  Future<void> updateChildProfile(String parentId, ChildProfile child) async {
    await _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(child.id)
        .update(child.toMap());
  }

  Future<void> deleteChildProfile(String parentId, String childId) async {
    await _db
        .collection('parents')
        .doc(parentId)
        .collection('children')
        .doc(childId)
        .delete();

    await _db.collection('parents').doc(parentId).update({
      'childProfileIds': FieldValue.arrayRemove([childId])
    });
  }
}
