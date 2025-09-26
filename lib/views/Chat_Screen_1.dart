import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itmessage/controllers/ChatControllerFirestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatUserId;
  const ChatScreen({super.key, required this.chatUserId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _chatController = InMemoryChatController();
  late ChatControllerFirestore _firestoreController;

  String _currentUserId = 'user1';

  @override
  void initState() {
    super.initState();
    _firestoreController = ChatControllerFirestore("default_room");

    _firestoreController.messagesStream().listen((messages) {
      // map ChatMessage -> TextMessage của flyer_chat
      final flyerMessages = messages.map((m) {
        return TextMessage(
          id: m.id,
          authorId: m.authorId,
          createdAt: m.createdAt,
          text: m.text,
        );
      }).toList();

      _chatController.setMessages(flyerMessages, animated: false);
    });
  }

  void _switchUser() {
    setState(() {
      _currentUserId = _currentUserId == 'user1' ? 'user2' : 'user1';
    });
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
        currentUserId: _currentUserId,
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
        onMessageSend: (text) {
          _firestoreController.sendMessage(_currentUserId, text);
        },
        resolveUser: (UserID id) async {
          if (id == 'user1') {
            return User(id: id, name: 'John Doe');
          } else if (id == 'user2') {
            return User(id: id, name: 'Alice');
          }
          return User(id: id, name: 'Unknown');
        },
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

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
}
