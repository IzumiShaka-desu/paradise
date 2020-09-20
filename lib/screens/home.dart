import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:paradise/components/drawer.dart';
import 'package:paradise/components/recomend_destination.dart';
import 'package:paradise/screens/add_or_edit.dart';
import 'package:paradise/screens/map_destination.dart';
import 'package:paradise/screens/profile.dart';
import 'package:paradise/services/auth_service.dart';
import 'package:paradise/utils.dart';

import '../constant.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = AuthService().auth.currentUser;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCust(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () => goTo(ProfileDetail(), context))
        ],
      ),
      body: LayoutBuilder(
        builder: (ctx, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
                          child: Container(
                  child:Container(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Paradise Indonesia',
                                            style: TextStyle(
                                                color: textDark,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 26),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Selamat Datang ${user.displayName}',
                                            style: TextStyle(
                                                color: textGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          )),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(child: RecommendDestination()),
                              SizedBox(height: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () =>goTo(MapDestination(),context),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 10, 10, 20),
                                            child: Text(
                                              'Lihat di peta',
                                              style: TextStyle(
                                                  color: textDark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ))
                                        ]),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                    color: Colors.blueAccent,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            'https://iklantravel.com/wp-content/uploads/2017/11/Peta-Wisata-Indonesia.png'),
                                                        fit: BoxFit.cover))),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => goTo(AddOrEdit(), context), child: Icon(Icons.add)),
    );
  }
}
