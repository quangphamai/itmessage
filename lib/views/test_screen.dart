import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class MultipleChatScreen extends StatefulWidget {
  
  const MultipleChatScreen({super.key});

  @override
  MultipleChatScreenState createState() => MultipleChatScreenState();
}

class MultipleChatScreenState extends State<MultipleChatScreen> {
  final _chatController1 = InMemoryChatController();
  final _chatController2 = InMemoryChatController();

  @override
  void dispose() {
    _chatController1.dispose();
    _chatController2.dispose();
    super.dispose();
  }
  final ImagePicker _picker = ImagePicker();

  String _currentUserId = 'user1';
  void _switchUser() {
    setState(() {
      _currentUserId = _currentUserId == 'user1' ? 'user2' : 'user1';
    });
  }

  // Method để gửi tin nhắn từ user1 sang user2
  void _sendMessageFromUser1(String text) {
    final message = TextMessage(
      id: '${Random().nextInt(10000)}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: text,
    );
    
    // Thêm tin nhắn vào cả 2 controller để hiển thị ở cả 2 khung
    _chatController1.insertMessage(message);
    _chatController2.insertMessage(message);
  }

  // Method để gửi tin nhắn từ user2 sang user1
  void _sendMessageFromUser2(String text) {
    final message = TextMessage(
      id: '${Random().nextInt(10000)}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: text,
    );
    
    // Thêm tin nhắn vào cả 2 controller để hiển thị ở cả 2 khung
    _chatController1.insertMessage(message);
    _chatController2.insertMessage(message);
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
        allowedExtensions: ['pdf','doc','docx','txt','jpg','png','gif','mp4','mp3','zip','rar',],
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
      if (context.mounted) {
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
        title: const Text('Dual Chat Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: _switchUser,
            tooltip: "Đổi user hiện tại: $_currentUserId",
          ),
        ],
      ),
      body: Column(
        children: [
          // Header hiển thị thông tin 2 user
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User 1 (John Doe)', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Current: $_currentUserId', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('User 2 (Alice)', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Current: ${_currentUserId == 'user1' ? 'user2' : 'user1'}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          // 2 khung chat
          Expanded(
            child: Row(
              children: [
                // Khung chat User 1
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blue[50],
                          child: const Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('John Doe (User 1)', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Chat(
                            chatController: _chatController1,
                            currentUserId: 'user1',
                            onMessageSend: (text) {
                              _sendMessageFromUser1(text);
                            },
                            resolveUser: (userId) async {
                              if (userId == 'user1') return User(id: userId, name: 'John Doe');
                              if (userId == 'user2') return User(id: userId, name: 'Alice');
                              return User(id: userId, name: 'Unknown');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Đường phân cách
                Container(
                  width: 2,
                  color: Colors.grey[400],
                ),
                // Khung chat User 2
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.green[50],
                          child: const Row(
                            children: [
                              Icon(Icons.person, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Alice (User 2)', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Chat(
                            chatController: _chatController2,
                            currentUserId: 'user2',
                            onMessageSend: (text) {
                              _sendMessageFromUser2(text);
                            },
                            resolveUser: (userId) async {
                              if (userId == 'user1') return User(id: userId, name: 'John Doe');
                              if (userId == 'user2') return User(id: userId, name: 'Alice');
                              return User(id: userId, name: 'Unknown');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
