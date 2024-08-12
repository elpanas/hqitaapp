import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:hive/hive.dart';

class Player extends ChangeNotifier {
  String? pid;
  String uid, name, phone, city, province;
  double latitude, longitude;
  bool fav;

  Player({
    this.pid,
    required this.uid,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
    required this.fav,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    var favList = Hive.box('favourites');
    bool fav = (favList.values.where(
      (element) => element.bid == json['_id'],
    )).isNotEmpty;
    return Player(
      pid: json['_id'],
      uid: json['uid'],
      name: json['name'],
      phone: json['phone'],
      latitude: json['location']['coordinates'][1],
      longitude: json['location']['coordinates'][0],
      city: json['city'],
      province: json['province'],
      fav: fav,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'location': {
          'type': "Point",
          'coordinates': [longitude, latitude]
        },
        'city': city,
        'province': province
      };
}
