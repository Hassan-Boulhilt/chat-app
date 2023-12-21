import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _db = FirebaseFirestore.instance;
User? loggedInUser;
bool displayed = false;
String? weekday;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String? userMessage;
  final TextEditingController _textInputControl = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } on Exception catch (e) {
      Text('$e: Failed to create your account, try later!');
    }
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  @override
  void dispose() {
    _textInputControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                context.pop();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const MyStreamBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textInputControl,
                      onChanged: (value) {
                        userMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final message = <String, dynamic>{
                        'sender': loggedInUser!.email,
                        'text': userMessage,
                        'dateCreated': DateTime.now(),
                        'weekday':
                            '${DateFormat.EEEE().format(DateTime.now())} ${DateFormat.d().format(DateTime.now())}',
                      };

                      _db.collection('messages').add(message);
                      _textInputControl.clear();
                      // displayed = false;
                      // print(displayed);
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyStreamBuilder extends StatelessWidget {
  const MyStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('messages').orderBy('dateCreated').snapshots(),
      builder: (context, snapshot) {
        List<Widget> textMessages = [];

        if (snapshot.hasData) {
          final messages = snapshot.data?.docs.reversed.toList();

          for (var message in messages!) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final createdAtDate = message['dateCreated'];
            weekday = message['weekday'];

            final Widget messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: loggedInUser?.email == messageSender,
              dateCreated: createdAtDate,
            );

            textMessages.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              children: textMessages,
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.dateCreated,
  });
  final String? sender;
  final String? text;
  final bool isMe;
  final Timestamp? dateCreated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
            textStyle: TextStyle(
              fontSize: 18,
              color: isMe ? Colors.white : Colors.black54,
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                text ?? '',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Text(
              DateFormat.Hm().format(dateCreated!.toDate()),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

Widget displayToday() {
  return Center(
    child: Material(
      color: const Color.fromARGB(99, 197, 191, 191),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          weekday!,
        ),
      ),
    ),
  );
}
