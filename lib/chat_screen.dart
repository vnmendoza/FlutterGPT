import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt/constant.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();


}
const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;
  //ChatGPT? chatGPT;
  Future<String> generateResponse(String prompt) async {
    const apiKey = apiSecretKey;
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );
    //decode response
    Map<String,dynamic>newResponse = jsonDecode(response.body);
    return newResponse['choices'][0]['text'];

  }
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    //chatGPT = ChatGPT.instance;
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, chatMessageType: ChatMessageType.user);
    // add the users message into array
    setState(() {
      _messages.insert(0, message);
      isLoading = true;
    });
    var input = _controller.text;
    _controller.clear();
    //Future.delayed(Duration(milliseconds: 50)).then(scroll

    // Call Chatbot API
    generateResponse(input).then((value)
    {
     setState(() {
       isLoading = false;
       ChatMessage botMessage = ChatMessage(text: value , chatMessageType: ChatMessageType.bot,);
       _messages.insert(0, botMessage);
     });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _controller,
          onSubmitted: (value) => _sendMessage(),
          style: TextStyle(color: Colors.white),
          decoration:
              const InputDecoration.collapsed(hintText: "Send a Message",
                  hintStyle: TextStyle(color: Colors.white60)),
        )),
        Visibility( visible: !isLoading,
            child: Container(
          color: backgroundColor,
          child: IconButton(onPressed: () => _sendMessage(),
              icon: const Icon(Icons.send,color: Colors.white,)),
        ))
      ],
    ).px16();
  }

  Widget _buildList() {
    return ListView.builder(
      reverse: true,
      padding: Vx.m8,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessage(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
          Text("Pixel8 ChatGPT",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),),
          ],
        ),
          backgroundColor: backgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: Column(children: [
          Flexible(
            child: _buildList(),
          ),
          Visibility(
            visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: CircularProgressIndicator(color: Colors.white),
              )
          ),

          Container(
            decoration: const BoxDecoration(
              color: backgroundColor,
            ),
            child: _buildTextComposer(),
          )
        ])));
  }
}
