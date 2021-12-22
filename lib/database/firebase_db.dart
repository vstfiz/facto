import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto/model/ads.dart';
import 'package:facto/model/category.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/model/feeds.dart';
import 'package:facto/model/rss.dart';
import 'package:facto/util/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/model/rss_urls.dart';
import 'package:facto/model/user.dart' as u;

class FirebaseDB {
  static Future<bool> getUserDetails(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot = await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    Globals.isDeleted = ds.length == 0 ? true : false;
    if (!Globals.isDeleted) {
      DocumentSnapshot document = ds.single;
      print(Globals.userLevel);
      Globals.userLevel = document['role'];
      Globals.user = new u.User(document['name'], document['email'],
          document['displayUrl'], document['uid']);
      print(Globals.user.toString());
      return document['status'] == 'Unlock' ? true : false;
    }
    return true;
  }

  static Future<void> createUser(String uid, String email, String name,
      String role, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    await ref.add({
      'name': name,
      'uid': uid,
      'email': email,
      'displayUrl': 'images/display_picture_defaults/' +
          name.toUpperCase().substring(0, 1) +
          '.png',
      'factCheck': 0,
      'feeds': 0,
      'status': 'Lock',
      'role': role
    });
  }

  static Future<void> deleteUser(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot = await ref.where('uid', isEqualTo: uid).get();
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).delete();
  }

  static Future<void> lockUser(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot = await ref.where('uid', isEqualTo: uid).get();
    var curr = querySnapshot.docs.single['status'];
    var newStatus = curr == 'Lock' ? 'Unlock' : 'Lock';
    print(curr);
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).update({'status': newStatus});
  }

  static Future<List<u.User>> getFeedForHome(
      bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot = await ref.get();
    var value = new List.filled(0, u.User.forHome('', 0, 0,''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(
          element['name'], element['factCheck'], element['feeds'],element['email']));
    });
    return value;
  }

  static Future<List<u.User>> getFeedForHomeWithDate(
      String time, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('logs');
    QuerySnapshot querySnapshot =
        await ref.where('time', isEqualTo: time).get();
    var value = new List.filled(0, u.User.forHome('', 0, 0,''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forHome(
          element['name'], element['factCheck'], element['feeds'],element['email']));
    });
    return value;
  }

  static Future<List<Claims>> getClaims(
      bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot = await ref
        .where('isClaim', isEqualTo: true)
        .where('feedType', isEqualTo: feedType)
        .get();
    var value = new List.filled(0, Claims('', '', '', '', '', false, ''),
        growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      try{
        value.add(new Claims(
            element['requestedBy'],
            element['time'],
            element['news'],
            element['status'],
            element['factCheck'],
            false,
            element['claimId']));
    }
      catch(e){
      print(element['news']);
    }
    });
    return value;
  }

  static Future<List<Claims>> getFilteredClaims(
      bool feedType, String status, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot = await ref
        .where('isClaim', isEqualTo: true)
        .where('feedType', isEqualTo: feedType)
        .where('status', isEqualTo: status)
        .get();
    var value = new List.filled(0, Claims('', '', '', '', '', false, ''),
        growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Claims(
          element['requestedBy'],
          element['time'],
          element['news'],
          element['status'],
          element['factCheck'],
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
    DocumentSnapshot ds = querySnapshot.docs.single;
    await ref.doc(di).update({
      'status': 'True',
      'factCheck': Globals.user.name,
    });
    ref = firestore.collection('feeds');
    await ref.add({
      'news': ds['news'],
      'truth': ds['news'],
      'url1': ds['url1'],
      'tags': [''],
      'geo': '',
      'language': '',
      'category': '',
      'url2': ds['url2'],
      'claimId': ds['claimId'],
      'feedType': ds['feedType'],
      'time': DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString(),
      'status': 'True',
      'requestedBy': Globals.user.name,
      'clicks': 0,
      'impressions': 0,
      'comment': '',
      'description': '',
    });
    await updateFactCheckCount();
  }

  static Future<void> rejectClaim(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': 'Rejected',
      'factCheck': Globals.user.name,
    });
    await updateFactCheckCount();
  }

  static Future<Claims> getClaimFromId(String claimId) async {
    print('getting data from : ' + claimId);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print('length is' + ds.length.toString());
    DocumentSnapshot di = ds.single;
    Claims value = new Claims.fromId(
        di['requestedBy'],
        di['time'],
        di['news'],
        di['url1'],
        di['url2'],
        di['feedType'] == true ? 'Image' : 'Video',
        di['description'],
        di['language'],
        '',
        di['category'],
        '',
        [''],
        di['comment'],di['status']);
    return value;
  }

  static Future<void> updateClaim(
      String comment, String status, String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    DocumentSnapshot ds = querySnapshot.docs.single;
    await ref.doc(di).update({
      'status': status,
      'comment': comment,
      'factCheck': Globals.user.name,
    });
    if(status == 'True'){
      ref = firestore.collection('feeds');
      await ref.add({
        'news': ds['news'],
        'truth': ds['news'],
        'url1': ds['url1'],
        'tags': [''],
        'geo': '',
        'language': '',
        'category': '',
        'url2': ds['url2'],
        'claimId': ds['claimId'],
        'feedType': ds['feedType'],
        'time': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'status': 'True',
        'requestedBy': Globals.user.name,
        'clicks': 0,
        'impressions': 0,
        'comment': '',
        'description': '',
      });
    }
    else if(status == "Rejected"){
      ref = firestore.collection('feeds');
      querySnapshot = await ref.where('claimId',isEqualTo: claimId).get();
      if(querySnapshot.docs.isNotEmpty){
        di = querySnapshot.docs.single.id;
        await ref.doc(di).delete();
      }
    }
    await updateFactCheckCount();
  }

  static Future<List<Claims>> getPartnerRequests(
      bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot = await ref
        .where('isPartnerRequest', isEqualTo: true)
        .where('feedType', isEqualTo: feedType)
        .get();
    var value = new List.filled(0, Claims('', '', '', '', '', false, ''),
        growable: true);
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

  static Future<List<Claims>> getFilteredPartnerRequests(
      bool feedType, String status, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    QuerySnapshot querySnapshot = await ref
        .where('isPartnerRequest', isEqualTo: true)
        .where('feedType', isEqualTo: feedType)
        .where('status', isEqualTo: status)
        .get();
    var value = new List.filled(0, Claims('', '', '', '', '', false, ''),
        growable: true);
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
    await updateFactCheckCount();
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
    await updateFactCheckCount();
  }

  static Future<Claims> getPartnerRequestFromId(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    DocumentSnapshot di = ds.single;
    Claims value = new Claims.fromId(
        di['requestedBy'],
        di['time'],
        di['news'],
        di['url1'],
        di['url2'],
        di['feedType'] == true ? 'Image' : 'Video',
        di['description'],
        di['language'],
        di['geo'],
        di['category'],
        di['truth'],
        di['tags'],
        di['comment'],di['status']);
    return value;
  }

  static Future<void> updatePartnerRequest(
      String comment, String status, String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref.doc(di).update({
      'status': status,
      'comment': comment,
    });
    await updateFactCheckCount();
  }

  static Future<List<RSSs>> getRSS(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot = await ref.get();
    var value =
        new List.filled(0, RSSs('', '', '', '', '', false, ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(element['source'], element['time'], element['title'],
          element['status'], element['assigned'], false, element['rssId']));
    });
    return value;
  }

  static Future<List<RSSs>> getFilteredRSS(
      String status, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
        await ref.where('status', isEqualTo: status).get();
    var value =
        new List.filled(0, RSSs('', '', '', '', '', false, ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(element['source'], element['time'], element['title'],
          element['status'], element['assigned'], false, element['rssId']));
    });
    return value;
  }

  static Future<List<int>> getCountHome() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
    await ref.where('status', isEqualTo: 'True').get();
    var value = List.filled(4, 0);
    value[0] = querySnapshot.docs.length;
    ref = firestore.collection('claims');
    querySnapshot =
    await ref.where('status', isEqualTo: 'Pending').get();
    value[1] = querySnapshot.docs.length;
    ref = firestore.collection('feeds');
    querySnapshot =
    await ref.where('status', isEqualTo: 'Pending').get();
    value[2] = querySnapshot.docs.length;
    ref = firestore.collection('feeds');
    querySnapshot =
    await ref.where('status', isEqualTo: 'True').get();
    value[3] = querySnapshot.docs.length;
    return value;
  }

  static Future<List<int>> getCountReview() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
    await ref.where('status', isEqualTo: 'Pending').get();
    var value = List.filled(4, 0);
    value[0] = querySnapshot.docs.length;
    ref = firestore.collection('feeds');
    querySnapshot =
    await ref.where('status', isEqualTo: 'True').get();
    value[1] = querySnapshot.docs.length;
    ref = firestore.collection('feeds');
    querySnapshot =
    await ref.where('status', isEqualTo: 'Pending').where('feedType', isEqualTo: false).get();
    value[2] = querySnapshot.docs.length;
    ref = firestore.collection('feeds');
    querySnapshot =
    await ref.where('status', isEqualTo: 'True').where('feedType', isEqualTo: false).get();
    value[3] = querySnapshot.docs.length;
    return value;
  }

  static Future<List<RSSs>> getFilteredRSSClosed(
      String status, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rss');
    QuerySnapshot querySnapshot =
        await ref.where('status', isEqualTo: 'True').get();
    var value =
        new List.filled(0, RSSs('', '', '', '', '', false, ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(element['source'], element['time'], element['title'],
          element['status'], element['assigned'], false, element['rssId']));
    });
    querySnapshot = await ref.where('status', isEqualTo: 'Rejected').get();
    ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new RSSs(element['source'], element['time'], element['title'],
          element['status'], element['assigned'], false, element['rssId']));
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

  static Future<void> updateRSS(
      String comment, String status, String rssId) async {
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
      value.add(new Ads(element['client'], element['createdBy'],
          element['impressions'], true, element['value']));
    });
    return value;
  }

  static Future<void> createAd(
      String url, String val, String client, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('ads');
    await ref.add({
      'client': client,
      'url': url,
      'value': val,
      'impressions': 0,
      'createdBy': Globals.user.name,
      'uidCreatedBy': Globals.user.uid,
      'isActive': true,
    });
  }

  static Future<List<u.User>> getUsers(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot = await ref.get();
    var value = new List.filled(0, u.User('', '', '', ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forManage(
          element['name'],
          element['uid'],
          element['status'],
          element['role'],
          element['factCheck'],
          element['feeds']));
    });
    return value;
  }

  static Future<List<u.User>> getFilteredUsers(String val) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot = await ref.where('role', isEqualTo: val).get();
    var value = new List.filled(0, u.User('', '', '', ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new u.User.forManage(
          element['name'],
          element['uid'],
          element['status'],
          element['role'],
          element['factCheck'],
          element['feeds']));
    });
    return value;
  }

  static Future<void> addCategory(String category,String url, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('category');
    await ref.add({
      'name': category,
      'url': url,
    });
  }

  static Future<void> removeCategory(String category, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('category');
    QuerySnapshot qs = await ref.where('name',isEqualTo: category).get();
    String id = qs.docs.single.id;
    await ref.doc(id).delete();
  }
  static Future<void> addGeo(String category, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('geo');
    await ref.add({
      'name': category,
    });
  }

  static Future<void> addRSSUrl(String url, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rssUrls');
    await ref.add({
      'url': url,
      'status' : 'Unlock',
      'time' : Timestamp.now()
    });
  }

  static Future<List<Category>> getCategory(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('category');
    QuerySnapshot querySnapshot =
        await ref.orderBy('name', descending: false).get();
    var value = new List.filled(0, Category('', ''), growable: true);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Category(element['name'], element['url']));
    });
    return value;
  }
  static Future<List<String>> getGeo(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('geo');
    QuerySnapshot querySnapshot =
    await ref.get();
    List<String> value = [];
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print('lengthd'+ds.length.toString());
    ds.forEach((element) {
      print(element['name']);
      value.add(element['name'].toString());
    });
    return value;
  }

  static Future<List<RSSUrls>> getRSSUrls(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rssUrls');
    var value = List.filled(0, RSSUrls('', '', new Timestamp.now()), growable: true);
    QuerySnapshot querySnapshot =
    await ref.get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print('lengthd'+ds.length.toString());
    ds.forEach((element) {
      print(element['url']);
      value.add(new RSSUrls(element['url'],element['status'],element['time']));
    });
    return value;
  }

  static Future<void> lockUrl(BuildContext context, String url,String status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('rssUrls');
    QuerySnapshot querySnapshot =
    await ref.where('url', isEqualTo: url).get();
    String id = querySnapshot.docs.single.id;
    if(status == 'Unlock'){
      await ref.doc(id).update({
        'status' : status,
      });
    }
    else{
      DateTime dt = DateTime.now();
      DateTime dt1 = DateTime.utc(dt.year,dt.month==12?1:dt.month+1,dt.day);
      await ref.doc(id).update({
        'status' : status,
        'time' : Timestamp.fromDate(dt1)
      });
    }
  }

  static Future<void> createFeed(claim, truth, url1, tags, country, language,
      category, url2, claimId, feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    await ref.add({
      'news': claim,
      'truth': truth,
      'url1': url1,
      'tags': tags,
      'geo': country,
      'language': language,
      'category': category,
      'url2': url2,
      'claimId': claimId,
      'feedType': feedType,
      'time': DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString(),
      'status': 'Pending',
      'requestedBy': Globals.user.name,
      'clicks': 0,
      'impressions': 0,
      'comment': '',
      'description': '',
    });
    await updateFeedsCount();
  }

  static Future<List<Feeds>> getRejectedFeeds(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('status', isEqualTo: 'Rejected').get();
    var value = new List.filled(0, Feeds.rejected('', '', '', '', true),
        growable: true);
    print(querySnapshot.docs.length);
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Feeds.rejected(element['news'], element['time'],
          element['requestedBy'], element['claimId'], element['feedType']));
    });
    return value;
  }

  static Future<List<dynamic>> getRejFeedFromId(
      String claimId, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    var value = [];
    DocumentSnapshot ds = querySnapshot.docs.single;
    value = [ds['news'], ds['time'], ds['comment'], ds['url2'], ds['status']];
    return value;
  }

  static Future<void> deleteFeed(String claimId, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).delete();
    await updateFeedsCount();
  }

  static Future<void> updateRejFeedWithData(String comment,String date,String claim,
      String status, String claimId, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).update({'status': status,'comment': comment,'news': claim,'time': date});
    await updateFeedsCount();
  }

  static Future<void> updateRejFeed(
      String status, String claimId, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
    await ref.where('claimId', isEqualTo: claimId).get();
    String id = querySnapshot.docs.single.id;
    await ref.doc(id).update({'status': status,});
    await updateFeedsCount();
  }

  static Future<void> createVideoFeed(claim,truth, url1, tags, country, category,
      url2, claimId, feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    await ref.add({
      'news': claim,
      'truth': truth,
      'url1': url1,
      'tags': tags,
      'geo': country,
      'category': category,
      'url2': url2,
      'claimId': claimId,
      'feedType': feedType,
      'time': DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString(),
      'status': 'Pending',
      'requestedBy': Globals.user.name,
      'clicks': 0,
      'impressions': 0,
    });
    await updateFeedsCount();
  }

  static Future<List<Feeds>> getReviewFeed(
      bool language, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    var value = List.filled(
        0, new Feeds.forReview('', 'time', 'claim', false, '', false),
        growable: true);
    QuerySnapshot querySnapshot = await ref
        .where('status', isEqualTo: 'Pending')
        .where('feedType', isEqualTo: true)
        .where('language', isEqualTo: language ? 'English' : 'Hindi')
        .get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print(ds.length);
    ds.forEach((element) {
      value.add(new Feeds.forReview(element['requestedBy'], element['time'],
          element['news'], false, element['claimId'], element['feedType']));
    });
    return value;
  }

  static Future<List<Feeds>> getFilteredReviewFeeds(
      String status, bool feedType, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    var value = List.filled(
        0, new Feeds.forReview('', 'time', 'claim', false, '', false),
        growable: true);
    QuerySnapshot querySnapshot;
    print(status + feedType.toString());
    if (feedType) {
      querySnapshot = await ref.where('status', isEqualTo: status).get();
    } else {
      querySnapshot = await ref
          .where('status', isEqualTo: status)
          .where('feedType', isEqualTo: false)
          .get();
    }
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Feeds.forReview(element['requestedBy'], element['time'],
          element['news'], false, element['claimId'], element['feedType']));
    });
    return value;
  }

  static Future<void> publishFeeds(String claimId, bool feedType) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('claimId', isEqualTo: claimId).get();
    String di = querySnapshot.docs.single.id;
    await ref
        .doc(di)
        .update({'status': 'True', 'publishedBy': Globals.user.name});
    await updateFeedsCount();
  }

  static Future<List<Feeds>> getPublishedFeeds(
      bool type, bool language, BuildContext context) async {
    print(type.toString() + language.toString());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot;
    if (type) {
      querySnapshot = await ref
          .where('status', isEqualTo: 'True')
          .where('feedType', isEqualTo: true)
          .where('language', isEqualTo: language ? 'English' : 'Hindi')
          .get();
      var value = List.filled(
          0,
          Feeds.published('claim', 'language', false, 'time', 'status',
              'publisher', 0, 0, ''),
          growable: true);
      List<DocumentSnapshot> ds = querySnapshot.docs;
      print('length' + ds.length.toString());
      ds.forEach((element) {
        try{
          value.add(new Feeds.published(
              element['news'],
              element['language'],
              element['feedType'],
              element['time'],
              element['status'],
              element['publishedBy'],
              element['impressions'],
              element['clicks'],
              element['claimId']));
        }
        catch(e){
          print(element['news']);
        }
      });
      return value;
    } else {
      querySnapshot = await ref
          .where('status', isEqualTo: 'True')
          .where('feedType', isEqualTo: false)
          .get();
      var value = List.filled(
          0,
          Feeds.published('claim', 'language', false, 'time', 'status',
              'publisher', 0, 0, ''),
          growable: true);
      List<DocumentSnapshot> ds = querySnapshot.docs;
      print('length' + ds.length.toString());
      ds.forEach((element) {
        value.add(new Feeds.published(
            element['news'],
            '',
            element['feedType'],
            element['time'],
            element['status'],
            element['publishedBy'],
            element['impressions'],
            element['clicks'],
            element['claimId']));
      });
      return value;
    }
  }

  static Future<void> updateFeedsCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
        await ref.where('uid', isEqualTo: Globals.user.uid).get();
    String id = querySnapshot.docs.single.id;
    int previousCount = querySnapshot.docs.single['feeds'];
    await ref.doc(id).update({
      'feeds': previousCount + 1,
    });
  }

  static Future<void> updateFactCheckCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    QuerySnapshot querySnapshot =
        await ref.where('uid', isEqualTo: Globals.user.uid).get();
    String id = querySnapshot.docs.single.id;
    int previousCount = querySnapshot.docs.single['factCheck'];
    await ref.doc(id).update({
      'factCheck': previousCount + 1,
    });
  }
}
