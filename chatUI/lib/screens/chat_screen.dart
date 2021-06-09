import 'package:chatUI/models/message_model.dart';
import 'package:chatUI/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 15.0,
      ),
      width: MediaQuery.of(context).size.width * 0.65,
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey.shade200,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(
                  15.0,
                ),
                bottomLeft: Radius.circular(15.0))
            : BorderRadius.only(
                topRight: Radius.circular(
                  15.0,
                ),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    String inputText;
    final inputTextController = TextEditingController();

    clearTextInput() {
      inputTextController.clear();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.photo,
              ),
              iconSize: 25.0,
              color: Colors.blue,
              onPressed: () {}),
          Expanded(
              child: TextField(
            controller: inputTextController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              inputText = value;
            },
            decoration:
                InputDecoration.collapsed(hintText: 'Write a message...'),
          )),
          IconButton(
              icon: Icon(
                Icons.send,
              ),
              iconSize: 25.0,
              color: Colors.blue,
              onPressed: () {
                clearTextInput();
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('kk:mm').format(now);
                setState(() {
                  if (inputText != null) {
                    messages.add(
                      Message(
                        sender: currentUser,
                        time: formattedDate,
                        text: inputText,
                        isLiked: false,
                        unread: true,
                      ),
                    );
                  }
                });
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(widget.user.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  iconSize: 30.0,
                  color: Colors.black54,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30.0,
                    ),
                    topRight: Radius.circular(
                      30.0,
                    ),
                  ),
                ),
                child: ClipRRect(
                  child: ListView.builder(
                    // reverse: true,
                    padding: EdgeInsets.only(
                      top: 15.0,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      final Message message = messages[index];
                      final bool isMe = message.sender.id == currentUser.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
