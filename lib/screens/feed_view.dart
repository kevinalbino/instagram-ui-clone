import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final postsRef = FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true);

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              dense: true,
              title: Text(doc["fullName"],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.blue),),
              subtitle:  Text(doc["message"],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.redAccent,
                child: ClipOval(
                  child: Image.asset('assets/icons/user.png', color: Colors.white70, scale: 1.1,)
                )
              ),
              trailing: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.favorite_outline),
                color: Colors.black,
                iconSize: 30,
              ),
            ),
            const Divider(
              height: 25,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [

          StreamBuilder<QuerySnapshot>(
            stream: postsRef.snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Container(
                child: _buildList(snapshot.data!)
              );
            }
          ),
        ],
      )
    );
  }
}