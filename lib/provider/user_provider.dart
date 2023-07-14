import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/constant.dart';
import '../model/login_user.dart';

class UserProvider with ChangeNotifier{
  List<LoginUser> _users = [];

  List<LoginUser> get getUsers{
    return [..._users];
  }

  LoginUser? getUserByMail(String mail){
    int index = _users.indexWhere((u) => u.mail.compareTo(mail)==0);
    if(index < 0){
      return null;
    }
    return _users[index];
  }

  bool isUserNotInDB(String mail){
    int index = _users.indexWhere((u) => u.mail.compareTo(mail)==0);
    return index < 0 ? true : false;
  }

  Future<void> fetchAndSetUsers() async {
    final response = await http.get(Uri.parse("${Constant.dbUrl}/users.json"));
    //print(response.body);
    List<LoginUser> loadedData = [];

    final extractedData = json.decode(response.body) as Map<String,dynamic>;

    if(extractedData.isEmpty) {
      return;
    }

    extractedData.forEach((id, data) {

      loadedData.add(
          LoginUser(id: id,fullName: data['name'],mail: data['mail'],phNo: data['phone'])
      );

    });
    _users = loadedData.toList();
    notifyListeners();
  }

  Future<void> addUser(LoginUser user) async{
    int existingIndex = _users.indexWhere((u) => u.mail.compareTo(user.mail) == 0);
    if(existingIndex >= 0) {
      return;
    }
    await http.post(Uri.parse("${Constant.dbUrl}/users.json"),body: json.encode({
      'name' : user.fullName,
      'mail' : user.mail,
      'phone' : user.phNo,


    })).then((response){
      _users.insert(0,
          LoginUser(id: json.decode(response.body)['name'],fullName: user.fullName, mail: user.mail, phNo: user.phNo));
      notifyListeners();
    });
  }

  Future<void> updateUser(LoginUser newUser) async {
    final existingUserIndex = _users.indexWhere((v) => v.id == newUser.id);

    final url = '${Constant.dbUrl}/users/${newUser.id}.json';

    try{
      final response = await http.patch(Uri.parse(url),body: json.encode({
        'name' : newUser.fullName,
        'mail' : newUser.mail,
        'phone' : newUser.phNo,

      }));
      LoginUser existingUser = _users[existingUserIndex];

      existingUser.fullName = newUser.fullName;
      existingUser.mail = newUser.mail;
      existingUser.phNo = newUser.phNo;

      _users[existingUserIndex] = existingUser;
      notifyListeners();

    }catch(error){
      print("$error From Error");
    }
  }
  Future<void> deleteUser(String id) async{
    final url = '${Constant.dbUrl}/users/$id.json';
    final existingIndex = _users.indexWhere((vc) => vc.id == id);
    LoginUser? existingUser = _users[existingIndex];
    _users.removeAt(existingIndex);
    final response = await http.delete(Uri.parse(url));
    if(response.statusCode >= 400){
      _users.insert(existingIndex, existingUser);
      notifyListeners();
    }
    existingUser = null;
    notifyListeners();
  }

}