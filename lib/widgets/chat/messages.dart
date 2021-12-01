import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  Future<User> loginUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSsnapshot) {
              if (chatSsnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSsnapshot.data.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  chatDocs[index]['userId'] == futureSnapshot.data.uid,
                  key: ValueKey(chatDocs[index].id),
                ),
              );
            });
      },
    );
  }
}
