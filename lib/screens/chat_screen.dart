import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/message_bubble.dart';
import 'welcome_screen.dart';

FirebaseUser loggedInUser;
final _fireStore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static const String route = "/chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FocusNode focusNode;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void handleSubmit() {
    try {
      if (messageText == "" || messageText == null) return;
      _fireStore.collection("messages").add({
        "text": messageText,
        "sender": loggedInUser.email,
        "timestamp": DateTime.now()
      });
      messageTextController.clear();
      FocusScope.of(context).requestFocus(focusNode);
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    try {
      await for (var snapshot
          in _fireStore.collection("messages").snapshots()) {
        for (var message in snapshot.documents) {
          print(message.data);
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.route);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      autofocus: true,
                      onSubmitted: (String data) {
                        handleSubmit();
                      },
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: handleSubmit,
                    child: Text(
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _fireStore.collection("messages").orderBy("timestamp").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final currentUser = loggedInUser.email;
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubles = [];
        for (var message in messages) {
          final messageSender = message.data["sender"];
          final messageText = message.data["text"];
          final messageBuble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender);
          messageBubles.add(messageBuble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubles,
          ),
        );
      },
    );
  }
}
