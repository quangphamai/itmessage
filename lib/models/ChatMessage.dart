class ChatMessage {
  final String id;
  final String authorId;
  final String text;
  final String type;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.authorId,
    required this.text,
    required this.type,
    required this.createdAt,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String docId) {
    return ChatMessage(
      id: docId,
      authorId: data['authorId'] ?? 'unknown',
      text: data['text'] ?? '',
      type: data['type'] ?? 'text',
      createdAt: (data['createdAt'])?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'text': text,
      'type': type,
      'createdAt': createdAt,
    };
  }
}
