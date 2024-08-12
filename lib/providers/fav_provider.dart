import 'package:hqitaapp/models/hive_model.dart';
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hqitaapp/providers/hqplayer_provider.dart';

class FavProvider extends ChangeNotifier {
  FavProvider(this.hqpP);

  final HQPlayerProvider? hqpP;
  List<dynamic> _favList = [];

  get favList => _favList;
  get favCount => _favList.length;

  loadFavList() {
    var box = Hive.box('favourites');
    _favList = box.values.toList();
    if (_favList.isEmpty) hqpP!.message = 'nohqps'.tr();
    notifyListeners();
  }

  addFav(int index) {
    var box = Hive.box('favourites');
    LocalPlayer singlePlayer = LocalPlayer(
      pid: hqpP!.player[index].bid!,
      name: hqpP!.player[index].name,
      city: hqpP!.player[index].city,
    );
    box.add(singlePlayer);
    hqpP!.player[index].fav = true;
    _favList = box.values.toList();
    notifyListeners();
  }

  delFav(String? bid) {
    var box = Hive.box('favourites');

    box.values.firstWhere((element) => element.bid == bid).delete();
    // hqpP!.player[index].fav = false;

    hqpP!.player.firstWhere((element) => element.bid == bid).fav = false;
    _favList = box.values.toList();
    if (_favList.isEmpty) hqpP!.message = 'nohqps'.tr();
    notifyListeners();
  }
}
