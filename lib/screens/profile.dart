import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paradise/services/auth_service.dart';
import 'package:paradise/services/firestorage_service.dart';

import '../utils.dart';

class ProfileDetail extends StatefulWidget {
  ProfileDetail({this.message});
  final String message;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileDetail> {
  Map<String, TextEditingController> controller = {
    'name': TextEditingController(),
    'email': TextEditingController(),
  };
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  User user;
  Map<String, String> mapUser;
  loadData() async {
    User _user = AuthService().auth.currentUser;
    setState(() {
      mapUser = {
        'name': _user.displayName,
        'email': _user.email,
      };
      user = _user;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget createUpdater(String identity, size, Function f) => Container(
          child: Card(
        child: ExpansionTile(
          trailing: Icon(Icons.edit),
          onExpansionChanged: (state) {
            if (state) {
              setState(() {
                controller[identity].text =
                    getValidString(mapUser[identity]) ?? '';
              });
            } else {
              setState(() {
                controller[identity].text = '';
              });
            }
          },
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.1,
                  right: size.width * 0.2,
                  top: 5,
                  bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller[identity],
                decoration: InputDecoration(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.6, right: size.width * 0.1, bottom: 10),
              child: FlatButton(
                  onPressed: () async {
                    f();
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      Text('save', style: TextStyle(color: Colors.white))
                    ],
                  )),
            )
          ],
          title: Text('$identity : ' +
              ((mapUser[identity] != null)
                  ? (mapUser[identity].isEmpty)
                      ? ' $identity not set'
                      : mapUser[identity]
                  : ' $identity not set')),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(title: Text(getValidString(widget.message) + 'Profil')),
      body: Container(
        padding: EdgeInsets.fromLTRB(2, 10, 2, 0),
        child: ListView(children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                      backgroundImage: NetworkImage('${user.photoURL}')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Transform.scale(
                        scale: 0.6,
                        child: InkWell(
                          onTap: () async {
                            try {
                              PickedFile pickedFile = await ImagePicker()
                                  .getImage(source: ImageSource.gallery);
                              File image = File(pickedFile.path);
                              bool change = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    'Apakah Anda yakin akan mengganti foto profil')),
                                          ],
                                        ),
                                        content: Column(children: [
                                          Expanded(
                                                                                      child: Image.file(image,
                                                ),
                                          )
                                        ]),
                                        actions: [
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              color: Colors.redAccent,
                                              child: Text('Batal')),
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              color: Colors.blueAccent,
                                              child: Text('Ya'))
                                        ],
                                      ));
                              if (change) {
                                StorageUploadTask task = FireStorageService()
                                    .storageRef
                                    .child(
                                        user.uid + "/photo-profile/profile.jpg")
                                    .putFile(image);
                                String url = await (await task.onComplete)
                                    .ref
                                    .getDownloadURL();
                                user.updateProfile(photoURL: url);
                                
                              _sk.currentState.showSnackBar(createSnackbar(
                                  'foto profil nerhasil diganti'));
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            loadData();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                              onPressed: null,
                              child: Row(
                                children: [
                                  Text('ganti foto profil'),
                                  Icon(Icons.edit),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          createUpdater('name', size, () async {
            if (controller['name'].text.isEmpty) {
              _sk.currentState
                  .showSnackBar(createSnackbar('field must not be empty'));
            } else {
              try {
                user.updateProfile(displayName: controller['name'].text);
                user.reload();
                _sk.currentState
                    .showSnackBar(createSnackbar('name successfully changed'));
              } catch (e) {
                _sk.currentState.showSnackBar(
                    createSnackbar('name not successfully changed'));
              }
            }
            loadData();
          }),
          createUpdater('email', size, () {
            if (controller['email'].text.isEmpty) {
              _sk.currentState
                  .showSnackBar(createSnackbar('field must not be empty'));
            } else {
              try {
                user.updateEmail(controller['email'].text);
                user.reload();
                _sk.currentState
                    .showSnackBar(createSnackbar('email successfully changed'));
              } catch (e) {
                _sk.currentState.showSnackBar(
                    createSnackbar('email not successfully changed'));
              }
            }
            loadData();
          })
        ]),
      ),
    );
  }
}
