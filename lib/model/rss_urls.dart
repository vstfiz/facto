import 'package:cloud_firestore/cloud_firestore.dart';

class RSSUrls{
  String url;
  String status;
  Timestamp time;

  RSSUrls(this.url, this.status, this.time);
}