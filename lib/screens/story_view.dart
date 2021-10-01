import 'package:flutter/material.dart';

class StoryView extends StatelessWidget {
  const StoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.only(top: 5.0),
      child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        child: ClipOval(
                          child: Image.asset('assets/users/test_user2.jpg')
                        )
                      ),
                    ),
                  ),
                  Text('    Liam Hill', textAlign: TextAlign.center),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        child: ClipOval(
                          child: Image.asset('assets/users/test_user1.jpg')
                        )
                      ),
                    ),
                  ),
                  Text('    Sally Watanabe', textAlign: TextAlign.center),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        child: ClipOval(
                          child: Image.asset('assets/users/test_user3.jpg')
                        )
                      ),
                    ),
                  ),
                  Text('    Owen Brown', textAlign: TextAlign.center),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        child: ClipOval(
                          child: Image.asset('assets/users/test_user4.jpg')
                        )
                      ),
                    ),
                  ),
                  Text('    Korey Walker', textAlign: TextAlign.center),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        child: ClipOval(
                          child: Image.asset('assets/users/test_user.jpg')
                        )
                      ),
                    ),
                  ),
                  Text('    Jason Schlatt', textAlign: TextAlign.center),
                ],
              ),
                
            ],
          ),
    );
  }
}