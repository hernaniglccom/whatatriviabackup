//import 'package:intl/intl.dart';

class AppUser {
  final String userId;
  AppUser({required this.userId});
}

class UserData{
  final String userId;
  final String userName;
  final String role;
  final List<String> organizations;
  UserData({required this.userId, required this.userName, required this.role, required this.organizations});

  @override
  String toString() => '$userId, $role, $userName';

}

class UserInformation {
  final String userName;
  final String role;
  final List<String> organizations;
  UserInformation({ required this.userName, required this.role, required this.organizations});
  @override
  String toString(){
    var returnText = '';

    return returnText;
  }
}