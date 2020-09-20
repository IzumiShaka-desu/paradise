import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Destination {
  String name;
  List<String> listImage;
  String details;
  String place;
  double lat;
  double long;
  DocumentReference ref;
  Destination(
      {@required this.details,
      @required this.lat,
      @required this.listImage,
      @required this.long,
      @required this.name,
      @required this.place,
      this.ref});
  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
      details: json['details'],
      lat: json['lat'],
      listImage: (json['listImage'] as List).map((e) => e.toString()).toList(),
      long: json['long'],
      name: json['name'],
      place: json['place']);
  Map<String,dynamic> get map => {
        'name': name,
        'listImage': listImage,
        'details': details,
        'place': place,
        'lat': lat,
        'long': long,
      };
}
