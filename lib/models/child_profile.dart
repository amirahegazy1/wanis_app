class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarUrl;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarUrl,
  });

  factory ChildProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return ChildProfile(
      id: documentId,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'avatarUrl': avatarUrl,
    };
  }
}
