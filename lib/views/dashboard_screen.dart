import 'package:flutter/material.dart';
import 'chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<ChatUser> _users = [
    ChatUser(
      id: 'user1',
      name: 'John Doe',
      lastMessage: 'Xin chào! Bạn có khỏe không?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      avatar: 'https://i.pravatar.cc/150?img=1',
      isOnline: true,
      unreadCount: 2,
    ),
    ChatUser(
      id: 'user2',
      name: 'Alice Smith',
      lastMessage: 'Hôm nay thời tiết đẹp quá!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      avatar: 'https://i.pravatar.cc/150?img=2',
      isOnline: false,
      unreadCount: 0,
    ),
    ChatUser(
      id: 'user3',
      name: 'Bob Johnson',
      lastMessage: 'Cảm ơn bạn đã giúp đỡ!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      avatar: 'https://i.pravatar.cc/150?img=3',
      isOnline: true,
      unreadCount: 1,
    ),
    ChatUser(
      id: 'user4',
      name: 'Emma Wilson',
      lastMessage: 'Tôi sẽ gửi file cho bạn sau',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      avatar: 'https://i.pravatar.cc/150?img=4',
      isOnline: false,
      unreadCount: 0,
    ),
    ChatUser(
      id: 'user5',
      name: 'Mike Brown',
      lastMessage: 'Cuộc họp lúc 2h chiều nhé',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      avatar: 'https://i.pravatar.cc/150?img=5',
      isOnline: true,
      unreadCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT Message'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status section
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddStatusItem();
                }
                final user = _users[index - 1];
                return _buildStatusItem(user);
              },
            ),
          ),
          const Divider(height: 1),
          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _buildChatItem(user);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildAddStatusItem() {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(left: 15, right: 10),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Your Story',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(ChatUser user) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.avatar),
              ),
              if (user.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            user.name.split(' ').first,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(ChatUser user) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.avatar),
          ),
          if (user.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontWeight: user.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        user.lastMessage,
        style: TextStyle(
          color: user.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
          fontWeight: user.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(user.lastMessageTime),
            style: TextStyle(
              color: user.unreadCount > 0 ? Colors.blue : Colors.grey[600],
              fontSize: 12,
              fontWeight: user.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (user.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                user.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatUserId: user.id),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

class ChatUser {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatar;
  final bool isOnline;
  final int unreadCount;

  ChatUser({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatar,
    required this.isOnline,
    required this.unreadCount,
  });
}
