import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../widgets/loading.dart';
import '../widgets/message.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';
  final FirebaseUser user;

  Widget _buildProfile(context) {
    return Padding(
      padding: EdgeInsets.all(8), 
      child: InkWell(
        child: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/profile', arguments: user);
        },
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return widgetLoading();
        User u = User.fromJson(snapshot.data.data);
        // Map<String, dynamic> u = snapshot.data.data;
        // if (u['level'] > 4) return Text('등급업이 필요합니다');
        if (u.level > 4) return widgetMessage('등급업이 필요합니다', Icons.error_outline);
        return widgetMessage('환영합니다', Icons.check_circle_outline);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: <Widget>[
          _buildProfile(context),          
        ],
      ),
      body: _buildBody(),
    );
  }
}