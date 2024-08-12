import 'package:hqitaapp/models/player_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class HQPlayerProvider extends ChangeNotifier {
  List<Player> _playerList = [];
  String _message = 'nohqps'.tr(), _uid = '';

  // VARS GETTERS
  get userId => _uid;
  get message => _message;
  get playerCount => _playerList.length;
  get player => _playerList;
  // ---------------------------------------------------------

  // VARS SETTERS
  set userId(userId) {
    _uid = userId;
    notifyListeners();
  }

  set message(value) {
    _message = value;
    notifyListeners();
  }

  set player(value) {
    _playerList = value;
    notifyListeners();
  }
  // ---------------------------------------------------------

  // LIST SETTERS
  addPlayerItem(Player value) {
    _playerList.add(value);
    notifyListeners();
  }

  editPlayerItem(Player value, int index) {
    _playerList[index] = value;
    notifyListeners();
  }

  removePlayerItem(int index) {
    _playerList.removeAt(index);
    if (_playerList.isEmpty) _message = 'nohqps'.tr();
    notifyListeners();
  }

  // coverage:ignore-start
  callNumber(int index) async {
    await launchUrl(Uri(scheme: 'tel', path: _playerList[index].phone));
  }

  openMap(int index) async {
    await MapsLauncher.launchCoordinates(
      _playerList[index].latitude,
      _playerList[index].longitude,
      _playerList[index].name,
    );
  }
  // coverage:ignore-end
  // ---------------------------------------------------------
}
