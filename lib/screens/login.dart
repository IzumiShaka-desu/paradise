import 'package:flutter/material.dart';
import 'package:paradise/services/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Container(
            width: size.width/2,
            height: size.width/2,
            child: Center(child: Image.asset('images/icon.png',)),),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: Container(
              
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(20),border: Border.all(color:Colors.grey[200],width: 2.00)),
              child:FlatButton(
                onPressed: ()=>AuthService().signInWithGoogle(),child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(child:Image.asset('images/google.png',width: size.width/6,)),SizedBox(width:10),Text('Login With Google')],),)
            ),
          )
        ]
      ),
      
    );
  }
}