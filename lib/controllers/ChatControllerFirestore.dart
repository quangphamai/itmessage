import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itmessage/models/ChatMessage.dart';

class ChatControllerFirestore {
  final _db = FirebaseFirestore.instance;
  final String roomId;

  ChatControllerFirestore(this.roomId);

  Stream<List<ChatMessage>> messagesStream() {
    return _db
        .collection('Chatrooms/$roomId/messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> sendMessage(String authorId, String text) async {
    final msg = {
      'authorId': authorId,
      'text': text,
      'type': 'text',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('Chatrooms/$roomId/messages').add(msg);
  }
}
