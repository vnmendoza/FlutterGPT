import 'package:chat_gpt/chat_screen.dart';
import 'package:flutter/material.dart';

enum ChatMessageType {user, bot}

class ChatMessage extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessage({
    super.key,
    required this.text,
    required this.chatMessageType
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? botBackgroundColor
          : backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot ?
          Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                backgroundColor: Colors.cyan,
                child: ImageIcon(AssetImage('assets/openai.png')
                ),
              )
          )
              : Container(
            margin: const EdgeInsets.only(right:16),
            child: const CircleAvatar(
              child: Icon(
                Icons.person,
              ),
            ),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),),
              )
            ],
          ))
        ],
      ),
    );
  }
}