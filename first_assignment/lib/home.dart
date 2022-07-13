import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_assignment/login.dart';
import 'package:first_assignment/registration.dart';
import 'package:first_assignment/user_form.dart';
import 'package:first_assignment/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:first_assignment/user_model.dart' as user_model;
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () => goToRegistration(context),
              icon: Icon(Icons.add_circle_outline)),
          IconButton(
              onPressed: () => logout(context),
              icon: Icon(Icons.power_settings_new)),
        ],
      ),
      // Stream builder to get users from FireStore and stream to observe any change
      body: StreamBuilder<List<user_model.User>>(
        stream: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;

            if (users.isEmpty) {
              return Text('No Data');
            }

            return ListView(
              children:
                  users.map((element) => buildUser(element, context)).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // List item widget to showcase each list item as per this widget
  Widget buildUser(user_model.User user, context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          '${user.age.toString()}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[300],
      ),
      title: Text('${user.name}'),
      subtitle: Row(
        children: [
          Expanded(child: Text('Email Id: ${user.email_id}')),
          Expanded(child: Text('Phone: ${user.phone}'))
        ],
      ),
      onTap: () {
        Provider.of<UserProvider>(context, listen: false).setSelectedUser(user);

        openRecord(context);
      },
    );
  }

  openRecord(context) {
    AlertDialog alert = AlertDialog(
      title: Text("Update/Delete Record"),
      actions: [
        UserForm.displayUserForm(context, 'update'),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  // Logout using FirebaseAuth
  Future logout(context) async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => Login())));
    });
  }

  // Takes to registration page
  goToRegistration(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Registration())));
  }

  // Read users from firestore and serialize them as per User class
  Stream<List<user_model.User>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => user_model.User.fromJson(doc.data()))
          .toList());
}
