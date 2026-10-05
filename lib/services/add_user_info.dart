import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserDatabaseMethods {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future addMembersInfo(
    String id,
    Map<String, dynamic> membersInfoMap,
    BuildContext context,
  ) async {
    try {
      // Check if the entry already exists right before writing it to the database

      final duplicateCheck = await _db
          .collection("members")
          .where("memberId", isEqualTo: id)
          .get();

      if (duplicateCheck.docs.isNotEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Member Already Exist")));
        return; // Stop the execution here!
      }

      // Add the member to the database if no duplicate was found

      await _db.collection('members').doc(id).set(membersInfoMap);
    } catch (e) {
      debugPrint("Payment Error: $e");
    }
  }
}
