import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_application/chat/chat_service.dart';
import 'package:doctor_application/common/components/chat_bubble.dart';
import 'package:doctor_application/common/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildMessageInput(),
      ]),
    );
  }

//build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
      
    );
  }

//build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Check if the message has a sender email and message text
    if (data.containsKey('senderEmail') && data.containsKey('message')) {
      // align the messages to the right if the sender is the current user, otherwise to the left
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
                // Display the sender email
                Text(
                  data['senderEmail'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ChatBubble(message: data['message']),
                // Display the message text
              ],
            ),
          ));
    } else {
      // Return an empty container if the message data is incomplete
      return Container();
    }
  }

//build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
          controller: _messageController,
          hintText: 'Enter message',
          obscureText: false,
        )),

        //send Button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        )
      ],
    );
  }
}
