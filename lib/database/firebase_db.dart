import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/model/user.dart' as u;

class FirebaseDB {
  static Future<User> getUserDetails(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    DocumentSnapshot document = ds.single;
      Globals.user = new u.User(
          document['name'],
          document['email'],
          document['displayUrl'],
          document['uid']);
      print(Globals.user.toString());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return HomeScreen(true);
      }));
    }

  static Future<List<u.User>> getFeedForHome(bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.get();
    var value = new List.filled(0, u.User.forHome('', 0,0),growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(element['name'],element[feedType==true?'factCheckImage':'factCheckVideo'],element[feedType==true?'feedsImage':'feedsVideo']));
    });
    return value;
  }
  static Future<List<u.User>> getFeedForHomeWithDate(String time, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('logs');
    QuerySnapshot querySnapshot =
    await ref.where('time', isEqualTo: time).get();
    var value = new List.filled(0, u.User.forHome('', 0, 0),growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(element['name'],element['factCheck'],element['feeds']));
    });
    return value;
  }
  static Future<List<Claims>> getClaims(bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isClaim', isEqualTo: true).where('feedType',isEqualTo: feedType).get();
    var value = new List.filled(0, Claims('', '', '', '', '', false,''),growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(element['requestedBy'], element['time'], element['news'], element['status'], element['factCheckBy'], false,element['claimId']));
    });
    return value;
  }
  static Future<List<Claims>> getFilteredClaims(bool feedType, String status,BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isClaim', isEqualTo: true).where('feedType',isEqualTo: feedType).where('status',isEqualTo: status).get();
    var value = new List.filled(0, Claims('', '', '', '', '', false,''),growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(element['requestedBy'], element['time'], element['news'], element['status'], element['factCheckBy'], false,element['claimId']));
    });
    return value;
  }
  static Future<void> approveClaim(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status' : 'True',
    });

  }

  static Future<void> rejectClaim(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status' : 'Rejected',
    });
  }

  static Future<List<dynamic>> getClaimFromId(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    DocumentSnapshot di = ds.single;
    var value = [di['requestedBy'], di['news'], di['url1'], di['url2'], di['description'],di['status']];
    return value;
  }
}