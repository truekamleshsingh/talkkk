import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../widgets/message_tile.dart';
import './group_info_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  final String groupId;
  final String groupName;
  final String userName;

  const ChatScreen({
    required this.groupId,
    required this.groupName,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String groupAdmin = '';

  void getGroupChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        groupAdmin = value;
      });
    });
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  sentByMe:
                      widget.userName == snapshot.data.docs[index]['sender'],
                ),
              )
            : const Center(
                child: Text(
                  'No messages here',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              );
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessagesMap = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessagesMap);

      setState(() {
        messageController.clear();
      });
    }
  }

  @override
  void initState() {
    getGroupChatAndAdmin();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        title: Text(
          widget.groupName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupInfoScreen(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    groupAdmin: groupAdmin,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: chatMessages(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              color: Colors.grey[300],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      sendMessage();
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
