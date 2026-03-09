enum ClassEmotion {
  happy,
  sad,
  angry,
  fearful,
  surprised,
  neutral,
  disgusted
}

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String type; // e.g., 'story', 'game', 'exercise'
  final List<ClassEmotion> targetEmotion;
  final String contentUrl;

  ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetEmotion,
    required this.contentUrl,
  });

  factory ContentItem.fromMap(Map<String, dynamic> data, String documentId) {
    return ContentItem(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      targetEmotion: (data['targetEmotion'] as List<dynamic>?)
              ?.map((e) => ClassEmotion.values.firstWhere(
                    (em) => em.toString() == 'ClassEmotion.$e',
                    orElse: () => ClassEmotion.neutral,
                  ))
              .toList() ??
          [],
      contentUrl: data['contentUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'targetEmotion': targetEmotion.map((e) => e.name).toList(),
      'contentUrl': contentUrl,
    };
  }
}
