import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paradise/services/auth_service.dart';
import 'package:paradise/services/firestorage_service.dart';

class DrawerCust extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerCust> {
  User user;
  String imageUrl;
  getUser() async {
    User _user = AuthService().auth.currentUser;
    String _imageUrl =
        _user.photoURL ?? (await FireStorageService().getUrl('defaultimg.png'));
    setState(() {
      user = _user;
      imageUrl = _imageUrl;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(user != null);
    user.reload();
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(children: [
                  DrawerHeader(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Transform.scale(
                                scale: 1.7,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl))),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              child:
                                  Text(user.email)),
                        ]),
                  ),
                  Container(height: 1, color: Colors.grey)
                ]),
              ),
              InkWell(
                onTap: () =>AuthService().signOut(),
                splashColor: Colors.redAccent,
                child: Container(
                  color: Colors.redAccent[200].withAlpha(190),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        )
                      ]),
                ),
              )
            ]),
      ),
    );
  }
}
