class ParentUser {
  final String id;
  final String email;
  final String name;
  final List<String> childProfileIds;
  final bool hasCompletedSurvey;
  final int activeDays;

  ParentUser({
    required this.id,
    required this.email,
    required this.name,
    this.childProfileIds = const [],
    this.hasCompletedSurvey = false,
    this.activeDays = 0,
  });

  factory ParentUser.fromMap(Map<String, dynamic> data, String documentId) {
    return ParentUser(
      id: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      childProfileIds: List<String>.from(data['childProfileIds'] ?? []),
      hasCompletedSurvey: data['hasCompletedSurvey'] ?? false,
      activeDays: data['activeDays'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'childProfileIds': childProfileIds,
      'hasCompletedSurvey': hasCompletedSurvey,
      'activeDays': activeDays,
    };
  }
}
