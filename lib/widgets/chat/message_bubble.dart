import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSenderMyself;
  final String userName;
  final String userImage;

  const MessageBubble({
    Key key,
    this.message,
    this.isSenderMyself,
    this.userName,
    this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isSenderMyself ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSenderMyself ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft: !isSenderMyself ? Radius.circular(0.0) : Radius.circular(12.0),
                  bottomRight: isSenderMyself ? Radius.circular(0.0) : Radius.circular(12.0),
                ),
              ),
              width: 140.0,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: isSenderMyself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(
                      color: isSenderMyself ? Colors.black : Theme.of(context).accentTextTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isSenderMyself ? Colors.black : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                    textAlign: isSenderMyself ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10.0,
          left: isSenderMyself ? null : 120.0,
          right: isSenderMyself ? 120.0 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
