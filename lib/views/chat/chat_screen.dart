import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  final String chatUserId;

  const ChatScreen({super.key, required this.chatUserId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _chatController = InMemoryChatController();

  final CollectionReference todos = FirebaseFirestore.instance.collection(
    'Chatrooms',
  );

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('Chatrooms/default_room/messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final messages = snapshot.docs.map((doc) {
            final data = doc.data();
            return TextMessage(
              id: doc.id,
              authorId: data['authorId'],
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              text: data['text'] ?? '',
            );
          }).toList();

          _chatController.setMessages(messages, animated: false);
        });
  }

  final ImagePicker _picker = ImagePicker();

  String _currentUserId = 'user1';
  void _switchUser() {
    setState(() {
      _currentUserId = _currentUserId == 'user1' ? 'user2' : 'user1';
    });
  }

  Future<void> onAttachmentTap(
    ChatController chatController,
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Chọn ảnh từ Gallery'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedFile != null) {
                      final imageMessage = ImageMessage(
                        id: '${Random().nextInt(100000)}',
                        authorId: 'user1',
                        createdAt: DateTime.now().toUtc(),
                        source: pickedFile.path,
                      );
                      chatController.insertMessage(imageMessage);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi khi chọn ảnh: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text('Chọn file'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [
                        'pdf',
                        'doc',
                        'docx',
                        'txt',
                        'jpg',
                        'png',
                        'gif',
                        'mp4',
                        'mp3',
                        'zip',
                        'rar',
                      ],
                      allowMultiple: false,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;

                      if (file.path != null) {
                        final fileMessage = FileMessage(
                          id: '${Random().nextInt(100000)}',
                          authorId: _currentUserId,
                          createdAt: DateTime.now().toUtc(),
                          name: file.name,
                          size: file.size,
                          source: file.path!,
                        );
                        chatController.insertMessage(fileMessage);
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi khi chọn file: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleFileSelection(ChatController chatController) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'jpg',
          'png',
          'gif',
          'mp4',
          'mp3',
          'zip',
          'rar',
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.path != null) {
          final fileMessage = FileMessage(
            id: '${Random().nextInt(100000)}',
            authorId: 'user1',
            createdAt: DateTime.now().toUtc(),
            name: file.name,
            size: file.size,
            source: file.path!,
          );
          chatController.insertMessage(fileMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.chatUserId}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: _switchUser,
            tooltip: "Đổi user",
          ),
        ],
      ),
      body: Chat(
        chatController: _chatController,
        currentUserId: 'user1',
        builders: Builders(
          fileMessageBuilder:
              (
                context,
                message,
                index, {
                required bool isSentByMe,
                MessageGroupStatus? groupStatus,
              }) => FlyerChatFileMessage(message: message, index: index),
          imageMessageBuilder:
              (
                context,
                message,
                index, {
                required bool isSentByMe,
                MessageGroupStatus? groupStatus,
              }) => FlyerChatImageMessage(message: message, index: index),
        ),

        onMessageSend: (text) async {
          final newMessage = {
            'id': '${Random().nextInt(1000) + 1}',
            'authorId': _currentUserId,
            'text': text,
            'type': 'text',
            'createdAt': FieldValue.serverTimestamp(),
          };

          //Send to firestore
          await FirebaseFirestore.instance
              .collection('Chatrooms/default_room/messages')
              .add(newMessage);
        },

        // onMessageSend: (text) {
        //   _chatController.insertMessage(
        //     TextMessage(
        //       // Better to use UUID or similar for the ID - IDs must be unique
        //       id: '${Random().nextInt(1000) + 1}',
        //       authorId: _currentUserId,
        //       createdAt: DateTime.now().toUtc(),
        //       text: text,
        //     ),
        //   );
        resolveUser: (UserID id) async {
          if (id == 'user1') {
            return User(id: id, name: 'John Doe');
          } else if (id == 'user2') {
            return User(id: id, name: 'Alice');
          }
          return User(id: id, name: 'Unknown');
        },
        onAttachmentTap: () => onAttachmentTap(_chatController, context),

        ///handle attachments
      ),
    );
  }

  // utils
  void _logAllMessages() {
    final list = _chatController.messages;
    debugPrint(
      '===== InMemoryChatController DUMP (count=${list.length}) =====',
    );

    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      final type = m.runtimeType.toString();
      // Tùy message type mà lấy thêm field “đặc trưng”
      String extra = '';
      if (m is TextMessage) {
        extra = 'text="${m.text}"';
      } else if (m is ImageMessage) {
        extra = 'imageSource="${m.source}"';
      } else if (m is FileMessage) {
        extra = 'fileName="${m.name}", size=${m.size}, source="${m.source}"';
      }
      final created = m.createdAt;

      debugPrint(
        '#$i '
        'type=$type | id=${m.id} | author=${m.authorId} | createdAt=$created'
        '${extra.isEmpty ? '' : ' | $extra'}',
      );
    }

    debugPrint('===== END DUMP =====');
  }
}
