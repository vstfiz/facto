import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto/model/ads.dart';
import 'package:facto/model/category.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/model/rss.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/auth/log_in.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/model/user.dart' as u;

class FirebaseDB {



  static Future<bool> getUserDetails(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    Globals.isDeleted = ds.length==0?true:false;
    if(!Globals.isDeleted){
      DocumentSnapshot document = ds.single;
      Globals.user = new u.User(
          document['name'],
          document['email'],
          document['displayUrl'],
          document['uid']);
      print(Globals.user.toString());
      return document['status'] == 'Unlock'?true:false;
    }
    return true;
  }

  static Future<void> createUser(String uid, String email, String name,String role,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    await ref.add({
      'name': name,
      'uid': uid,
      'email': email,
      'displayUrl': 'images/display_picture_defaults/' +
          name.toUpperCase().substring(0, 1) + '.png',
      'factCheckImage': 0,
      'factCheckVideo': 0,
      'feedsImage': 0,
      'feedsVideo': 0,
      'status' : 'Lock',
      'role' : role
    });
  }

  static Future<void> deleteUser(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).get();
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).delete();
  }

  static Future<void> lockUser(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).get();
    var curr = querySnapshot.docs.single['status'];
    var newStatus = curr=='Lock'?'Unlock':'Lock';
    print(curr);
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).update({
      'status' : newStatus
    });
  }

  static Future<List<u.User>> getFeedForHome(bool feedType,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.get();
    var value = new List.filled(0, u.User.forHome('', 0, 0), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(element['name'],
          element[feedType == true ? 'factCheckImage' : 'factCheckVideo'],
          element[feedType == true ? 'feedsImage' : 'feedsVideo']));
    });
    return value;
  }

  static Future<List<u.User>> getFeedForHomeWithDate(String time,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('logs');
    QuerySnapshot querySnapshot =
    await ref.where('time', isEqualTo: time).get();
    var value = new List.filled(0, u.User.forHome('', 0, 0), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(
          element['name'], element['factCheck'], element['feeds']));
    });
    return value;
  }

  static Future<List<Claims>> getClaims(bool feedType,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isClaim', isEqualTo: true).where(
        'feedType', isEqualTo: feedType).get();
    var value = new List.filled(0, Claims(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(
          element['requestedBy'],
          element['time'],
          element['news'],
          element['status'],
          element['factCheckBy'],
          false,
          element['claimId']));
    });
    return value;
  }

  static Future<List<Claims>> getFilteredClaims(bool feedType, String status,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isClaim', isEqualTo: true).where(
        'feedType', isEqualTo: feedType)
        .where('status', isEqualTo: status)
        .get();
    var value = new List.filled(0, Claims(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(
          element['requestedBy'],
          element['time'],
          element['news'],
          element['status'],
          element['factCheckBy'],
          false,
          element['claimId']));
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
      'status': 'True',
    });
  }

  static Future<void> rejectClaim(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': 'Rejected',
    });
  }

  static Future<List<dynamic>> getClaimFromId(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    DocumentSnapshot di = ds.single;
    var value = [
      di['requestedBy'],
      di['news'],
      di['url1'],
      di['url2'],
      di['description'],
      di['status']
    ];
    return value;
  }

  static Future<void> updateClaim(String comment, String status,
      String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': status,
      'comment': comment,
    });
  }
  static Future<List<Claims>> getPartnerRequests(bool feedType,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isPartnerRequest', isEqualTo: true).where(
        'feedType', isEqualTo: feedType).get();
    var value = new List.filled(0, Claims(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(
          element['requestedBy'],
          element['time'],
          element['news'],
          element['status'],
          element['factCheckBy'],
          false,
          element['claimId']));
    });
    return value;
  }
  static Future<List<Claims>> getFilteredPartnerRequests(bool feedType, String status,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('isPartnerRequest', isEqualTo: true).where(
        'feedType', isEqualTo: feedType)
        .where('status', isEqualTo: status)
        .get();
    var value = new List.filled(0, Claims(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(
          element['requestedBy'],
          element['time'],
          element['news'],
          element['status'],
          element['factCheckBy'],
          false,
          element['claimId']));
    });
    return value;
  }
  static Future<void> approvePartnerRequest(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': 'True',
    });
  }
  static Future<void> rejectPartnerRequest(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': 'Rejected',
    });
  }
  static Future<List<dynamic>> getPartnerRequestFromId(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    DocumentSnapshot di = ds.single;
    var value = [
      di['requestedBy'],
      di['news'],
      di['url1'],
      di['url2'],
      di['description'],
      di['status']
    ];
    return value;
  }
  static Future<void> updatePartnerRequest(String comment, String status,
      String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': status,
      'comment': comment,
    });
  }
  static Future<List<RSSs>> getRSS(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.get();
    var value = new List.filled(0, RSSs(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(
          element['source'],
          element['time'],
          element['title'],
          element['status'],
          element['assigned'],
          false,
          element['rssId']));
    });
    return value;
  }

  static String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static Future<List<RSSs>> getFilteredRSS(String status,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.where('status', isEqualTo: status).get();
    var value = new List.filled(0, RSSs(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(
          element['source'],
          element['time'],
          element['title'],
          element['status'],
          element['assigned'],
          false,
          element['rssId']));
    });
    return value;
  }

  static Future<List<RSSs>> getFilteredRSSClosed(String status,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.where('status', isEqualTo: 'True').get();
    var value = new List.filled(0, RSSs(
        '',
        '',
        '',
        '',
        '',
        false,
        ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(
          element['source'],
          element['time'],
          element['title'],
          element['status'],
          element['assigned'],
          false,
          element['rssId']));
    });
    querySnapshot = await ref.where('status', isEqualTo: 'Rejected').get();
    ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(
          element['source'],
          element['time'],
          element['title'],
          element['status'],
          element['assigned'],
          false,
          element['rssId']));
    });
    return value;
  }

  static Future<List<dynamic>> getRSSFromId(String rssId) async {
    print(rssId);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.where('rssId', isEqualTo: rssId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print(ds.length);
    DocumentSnapshot di = ds.single;
    var value = [di['source'], di['url'], di['description'], di['status']];
    print(value);
    return value;
  }

  static Future<void> updateRSS(String comment, String status,
      String rssId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.where('rss', isEqualTo: rssId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': status,
      'comment': comment,
    });
  }

  static Future<List<Ads>> getAds(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('ads');
    QuerySnapshot querySnapshot =
    await ref.where('isActive', isEqualTo: true).get();
    var value = new List.filled(0, Ads('', '', 0, true, ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Ads(
          element['client'], element['createdBy'], element['impressions'], true,
          element['value']));
    });
    return value;
  }

  static Future<void> createAd(String url, String val, String client,
      BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('ads');
    await ref.add({
      'client': client,
      'url': url,
      'value': val,
      'impressions': 0,
      'createdBy': Globals.user.name,
      'uidCreatedBy': Globals.user.uid,
      'isActive': true,});
  }

  static Future<List<u.User>> getUsers(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.get();
    var value = new List.filled(0, u.User('', '', '', ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forManage(
          element['name'], element['uid'], element['status'], element['role'],
          element['factCheckImage'] + element['factCheckVideo'],
          element['feedsImage'] + element['feedsVideo']));
    });
    return value;
  }

  static Future<List<u.User>> getFilteredUsers(String val) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
    await ref.where('role',isEqualTo: val).get();
    var value = new List.filled(0, u.User('', '', '', ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forManage(
          element['name'], element['uid'], element['status'], element['role'],
          element['factCheckImage'] + element['factCheckVideo'],
          element['feedsImage'] + element['feedsVideo']));
    });
    return value;
  }

  static Future<void> addCategory(String category,BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('category');
    await ref.add({
      'name' : category,
      'isLocked' : false,
      'url' : 'vgrfgvber',
    });
  }

  static Future<List<Category>> getCategory(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('category');
    QuerySnapshot querySnapshot =
    await ref.orderBy('name',descending: false).get();
    var value = new List.filled(0, Category('',false,''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Category(
          element['name'],element['isLocked'],element['url']));
    });
    return value;
  }
}