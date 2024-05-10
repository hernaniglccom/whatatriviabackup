import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatatrivia/private_classes/user.dart';

class UserDatabaseService{

  final String userId;
  UserDatabaseService({required this.userId});
  UserDatabaseService.withoutUserId() : userId = '';

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('userInfo');

  Future updateUserData(String userName, String role, List<dynamic> organizations) async {
    return await usersCollection.doc(userId).set({
      'userName': userName,
      'role' : role,
      'organizations': organizations,
    });
  }

  //get user list from snapshot to allow stream of a list of all users
  List<UserInformation> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserInformation(userName: doc.get('userName')??'', role: doc.get('role')??'', organizations: doc.get('organizations')??'');
    }).toList();
  }

  // get list of all users stream
  Stream<List<UserInformation>> get userInfo {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  //get userData from snapshot to allow stream of a single user
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return  UserData(userId: userId, role: snapshot['role'], userName: snapshot['userName'], organizations: snapshot['organizations']);
  }

  //get a single user doc stream
  Stream<UserData> get userData{
    return usersCollection.doc(userId).snapshots().map(_userDataFromSnapshot);
  }

}