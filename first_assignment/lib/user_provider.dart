import 'package:first_assignment/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  User? selectedUser;

  void setSelectedUser(value) {
    selectedUser = value;
  }

  User getSelectedUser() {
    return selectedUser!;
  }
  
}