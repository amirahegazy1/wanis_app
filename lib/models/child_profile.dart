class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarUrl;
  final Map<String, int> surveyResponses;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarUrl,
    this.surveyResponses = const {},
  });

  factory ChildProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return ChildProfile(
      id: documentId,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      avatarUrl: data['avatarUrl'] ?? '',
      surveyResponses: data['surveyResponses'] != null 
          ? Map<String, int>.from(data['surveyResponses']) 
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'avatarUrl': avatarUrl,
      'surveyResponses': surveyResponses,
    };
  }
}
