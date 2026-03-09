class ParentUser {
  final String id;
  final String email;
  final String name;
  final List<String> childProfileIds;

  ParentUser({
    required this.id,
    required this.email,
    required this.name,
    this.childProfileIds = const [],
  });

  factory ParentUser.fromMap(Map<String, dynamic> data, String documentId) {
    return ParentUser(
      id: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      childProfileIds: List<String>.from(data['childProfileIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'childProfileIds': childProfileIds,
    };
  }
}
