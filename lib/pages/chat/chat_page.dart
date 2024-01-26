import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/chat_bubble.dart';
import '../../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUsername;

  const ChatPage({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiverUsername,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUsername,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _messageController,
        decoration: InputDecoration(
          hintText: 'Write a message ...',
          // prefixIcon: const Icon(Icons.camera_alt),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (_messageController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
              // if (_messageController.text.isEmpty)
              //   GestureDetector(
              //     child: Icon(Icons.mic),
              //   ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade900),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Align current sender to the right, others to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            ChatBubble(message: data['message']),
            Text(
              _formatDateTime(data['timestamp']),
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime = "${dateTime.hour}:${dateTime.minute}";
    return formattedDateTime;
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No messages available.');
        }

        return ListView(
          children: snapshot.data!.docs
              .map(
                (document) => _buildMessageItem(document),
              )
              .toList(),
        );
      },
    );
  }

  Future<String?> _getReceiverFCMToken(String receiverUserEmail) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where('email', isEqualTo: receiverUserEmail)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        return userData?['FCM'];
      }
    } catch (e) {
      print('Error retrieving FCM token: $e');
      return null;
    }
  }
}
