import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
 String name;
 String email;
 String phone;

 UserModel({required this.name, required this.email, required this.phone,});

 factory UserModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>? ?? {};

  return UserModel(
      name: data['name'] ?? 'Unknown Name',
      email: data['email'] ?? 'Unknown Email',
      phone: data['phone'] ?? 'Unknown Phone',
  );
 }

 // 2. A method to convert the Model back to a Map for Firestore
 Map<String, dynamic> toMap() {
  return {
   'name': name,
   'email': email,
   'phone': phone,
  };
 }

}


