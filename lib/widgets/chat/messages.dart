import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  bool isSenderMyself(String userId) {
    final user = FirebaseAuth.instance.currentUser;

    if (user.uid == userId) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = chatSnapShot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            key: ValueKey(docs[index].id),
            message: docs[index]['text'],
            isSenderMyself: isSenderMyself(docs[index]['userId']),
            userName: docs[index]['userName'],
            userImage: docs[index]['userImage'],
          ),
        );
      },
    );
  }
}
