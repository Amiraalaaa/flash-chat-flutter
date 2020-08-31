import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isme;
  final String dateTime;
  MessageBubble({this.text,this.sender,this.isme,@required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.00),
      child: Column(
      crossAxisAlignment: isme? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius:  isme ? (BorderRadius.only(topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))) :( BorderRadius.only(bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))),
            color: isme ? Colors.lightBlueAccent : Colors.white ,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text('$text',style: TextStyle(
                fontSize: 15.00,
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
