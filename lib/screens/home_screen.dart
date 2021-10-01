import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:scuffedgram/screens/login_screen.dart';
import 'package:scuffedgram/screens/pop_up.dart';
import 'package:scuffedgram/services/google_sign_in.dart';
import 'story_view.dart';
import 'feed_view.dart';

final postsRef = FirebaseFirestore.instance.collection('posts');

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  TextEditingController messageController = TextEditingController();
  String postId = Uuid().v4();

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<String> _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    return snap['role'];
  }

  createPostInFirestore( {required String message} ) {
    postsRef
    .doc(postId)
    .set({
      "postUid": postId,
      "ownderUid": FirebaseAuth.instance.currentUser!.uid,
      "fullName": FirebaseAuth.instance.currentUser!.displayName,
      "message": message,
      "timestamp": DateTime.now(),
    });
  }

  handleSumbit() async {
    createPostInFirestore(
      message: messageController.text,
    );
    messageController.clear();
    setState(() {
      postId = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
        title: Text(
          'Scuffedgram',
          style: TextStyle(fontFamily: 'Billabong', fontSize: 35.0, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final action = await popUpView.yesCancelDialog(context, 'Logout', 'Are you sure?');
              if(action == DialogsAction.yes) {
                await GoogleSignInService().logOut();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => login_screen()));
              }
            },
            child: Container(
              height: 50,
              width: 25,
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),

      body: Stack(
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              StoryView(),
              FeedView(),
            ],
          ),
          Align(
            alignment: Alignment(0.9, 0.95),
            child: FutureBuilder(
              future: _checkRole(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container();
                  case ConnectionState.done:
                    if (snapshot.data == 'admin'){
                      return FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: Colors.red,
                        onPressed: () {
                          _userEditBottomSheet(context);
                        },
                      );
                    }
                    return Container();
                  default:
                    return Container();
                }
              }
            ),
          ),
        ]
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', scale: 2),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/search.png', scale: 2),
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/reels.png', scale: 2),
            label: 'Reels'
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/shop.png', scale: 2),
            label: 'Shop'
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/user.png', scale: 2),
            label: 'User'
          ),
        ],
      ),
    );
  }

  void _userEditBottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Post a new message"),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.cancel),
                          color: Colors.red,
                          iconSize: 25,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: TextField(
                              controller: messageController,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text('Post Message'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),)
                          ),
                          onPressed: () async {
                            handleSumbit();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}