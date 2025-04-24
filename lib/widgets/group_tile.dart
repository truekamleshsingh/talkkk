import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../screens/chat_screen.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({
    required this.userName,
    required this.groupId,
    required this.groupName,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants.primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 35,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            'Join the conversation as \'${widget.userName}\'',
          ),
        ),
      ),
    );
  }
}
