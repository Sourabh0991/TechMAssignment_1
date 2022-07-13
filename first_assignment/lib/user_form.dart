import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:first_assignment/user_model.dart';
import 'package:first_assignment/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm {
  static final _formKey = GlobalKey<FormState>();

  static TextEditingController nameController = new TextEditingController();
  static TextEditingController ageController = new TextEditingController();
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController phoneController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();

  static User? selectedUser;

  static Container displayUserForm(context, String operation) {
    if (operation.contains('update')) {
      selectedUser =
          Provider.of<UserProvider>(context, listen: false).getSelectedUser();

      nameController.text = selectedUser!.name;
      ageController.text = selectedUser!.age.toString();
      emailController.text = selectedUser!.email_id;
      phoneController.text = selectedUser!.phone;
      passwordController.text = selectedUser!.password;
    }

    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width * 0.33,
        height: MediaQuery.of(context).size.width * 0.33,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (value.contains(RegExp(r'[A-Z, a-z]'))) {
                      return 'Age is just a number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone No.'),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone no.';
                    }
                    if (value.contains(RegExp(r'[A-Z, a-z]'))) {
                      return 'Invalid phone number';
                    }
                    if (value.length != 10) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email Address'),
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Set Password'),
                  maxLines: 1,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please set a password';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: operation.contains('create')
                      ? ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );

                              createUser().then(
                                (value) => Navigator.pop(context),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  child: const Text('update'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );

                                      updateUser().then(
                                        (value) => Navigator.pop(context),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );

                                      deleteUser().then(
                                        (value) => Navigator.pop(context),
                                      );
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ],
            )));
  }

  static Future createUser() async {
    final firebaseUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
        id: firebaseUser.id,
        name: nameController.text,
        age: int.parse(ageController.text),
        email_id: emailController.text,
        phone: phoneController.text,
        password: passwordController.text);

    final json = user.toJson();

    await firebaseUser
        .set(json)
        .whenComplete(() => {_formKey.currentState!.reset()});
  }

  static Future updateUser() async {
    print('selectedUser!.id : ${selectedUser!.id}');
    final firebaseUser =
        FirebaseFirestore.instance.collection('users').doc(selectedUser!.id);

    final user = User(
        id: selectedUser!.id,
        name: nameController.text,
        age: int.parse(ageController.text),
        email_id: emailController.text,
        phone: phoneController.text,
        password: passwordController.text);

    final json = user.toJson();

    await firebaseUser.update(json);
  }

  static Future deleteUser() async {
    final firebaseUser =
        FirebaseFirestore.instance.collection('users').doc(selectedUser!.id);

    await firebaseUser.delete();
  }
}
