import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/messageBubble.dart';

final _firestore = FirebaseFirestore.instance;
User loggeduser ;

class ChatScreen extends StatefulWidget {

  static String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String textmessage;
  final textcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final _auth=FirebaseAuth.instance;
  void getUser() async{
    final user = await _auth.currentUser;
    if(user!=null){
      loggeduser =user;

    }
  }
void getmessagestream()async{
    await for(var snapshots in _firestore.collection('amira').snapshots())
      {
        for(var mess in snapshots.docs)
          print(mess.data());
      }

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
               Navigator.pop(context);
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
            Streambuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:  textcontroller ,
                      onChanged: (value) {
                        textmessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textcontroller.clear();
                      _firestore.collection('amira').add({
                        'text' : textmessage,
                        'sender':loggeduser.email,
                        'dateandtime' : DateTime.now().toString(),
                      });
                    },
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
class Streambuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('amira').snapshots(),
      builder: (context, snapshot) {
        final message = snapshot.data.docs.reversed;
        List<MessageBubble> messageswidget = [];
        for(var themesage in message)
        {
          final textmessage = themesage.data()['text'];
          final thesender = themesage.data()["sender"];
          final messageDateTime = themesage.data()['dateandtime'];
          final currentuser = loggeduser.email;

          final thetext = MessageBubble(text: textmessage,
              sender:thesender,
              isme:currentuser==thesender,
              dateTime: messageDateTime);
          messageswidget.add(thetext);
          messageswidget.sort((a,b)=>DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime),),);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 5.0,vertical:5.0),
            children: messageswidget,
          ),
        );
      },
    );
  }
}
