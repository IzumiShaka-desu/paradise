import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paradise/screens/home.dart';
import 'package:paradise/screens/login.dart';
import 'package:paradise/screens/profile.dart';
import 'package:paradise/services/auth_service.dart';

class PageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
              stream: AuthService().auth.authStateChanges(),
              builder:(ctx,snapshot)=>(!snapshot.hasData || snapshot.data==null)?Login():(snapshot.data.displayName==null)?ProfileDetail(message:'Lengkapi '):Home(),
      ),
    );
  }
}