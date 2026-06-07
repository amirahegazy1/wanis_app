class ChildProfile {
  final String id;
  final String name;
  final String ageCategory;
  final String avatarUrl;
  final Map<String, int> surveyResponses;

  ChildProfile({
    required this.id,
    required this.name,
    required this.ageCategory,
    required this.avatarUrl,
    this.surveyResponses = const {},
  });

  factory ChildProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return ChildProfile(
      id: documentId,
      name: data['name'] ?? '',
      ageCategory: data['ageCategory'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      surveyResponses: data['surveyResponses'] != null 
          ? Map<String, int>.from(data['surveyResponses']) 
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ageCategory': ageCategory,
      'avatarUrl': avatarUrl,
      'surveyResponses': surveyResponses,
    };
  }
}
