import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show GZipCodec, HttpHeaders;
import 'package:hqitaapp/constants.dart' show hashAuth, url;
import 'package:hqitaapp/functions.dart' show getPosition;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart' show Position;
import 'package:hqitaapp/providers/hqplayer_provider.dart';
import 'package:http/http.dart' as http;
import '../models/player_model.dart';

class HttpProvider extends ChangeNotifier {
  HttpProvider(this.hqpP);

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  final HQPlayerProvider? hqpP;

  bool _loading = false, _result = false;
  final _headersZip = {
    HttpHeaders.contentEncodingHeader: 'gzip',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $hashAuth',
  };
  final _header = {
    HttpHeaders.authorizationHeader: 'Bearer $hashAuth',
  };

  get loading => _loading;

  set loading(value) {
    _loading = value;
    notifyListeners();
  }

  // HANDLERS
  Future<bool> getHandler(http.Client client, String url) async {
    loading = true;
    hqpP!.message = 'loading'.tr();
    _result = false;
    try {
      final res = (hqpP!.userId == '')
          ? await client.get(Uri.parse(url))
          : await client.get(Uri.parse(url), headers: _header);
      if (res.statusCode == 200) {
        final resJson = jsonDecode(res.body);
        hqpP!.player =
            resJson.map<Player>((data) => Player.fromJson(data)).toList();
        _result = true;
      } else {
        hqpP!.message = 'nohqps'.tr();
      }
    } catch (e) {
      hqpP!.message = 'nohqps'.tr();
      throw Exception(e);
    } finally {
      loading = false;
    }
    return _result;
  }

  Future<bool> patchHandler(http.Client client, int index, int newValue) async {
    loading = true;
    _result = false;
    final body = jsonEncode(<String, dynamic>{
      'av_umbrellas': newValue,
    });
    final compressedBody = GZipCodec().encode(body.codeUnits);

    try {
      final res = await client.patch(
        Uri.parse('$url${hqpP!.player[index].bid!}'),
        headers: _headersZip,
        body: compressedBody,
      );

      if (res.statusCode == 200) {
        // hqpP!.setUmbrellas(newValue, index);
        _result = true;
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }

  Future<Player> makeRequest(
    String name,
    int avUmbrellas,
    int totUmbrellas,
    String phone,
    String city,
    String province,
  ) async {
    Position position = await getPosition();
    return Player(
      uid: hqpP!.userId,
      name: name,
      phone: phone,
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      province: province,
      fav: false,
    );
  }
  // ---------------------------------------------------------

  // GET
  // coverage:ignore-start
  Future<bool> loadPlayers() async {
    Position pos = await getPosition();
    return await getHandler(
        http.Client(), '${url}disp/coord/${pos.latitude}/${pos.longitude}');
  }

  Future<bool> loadPlayer(String bid) {
    return getHandler(http.Client(), '${url}player/$bid');
  }

  Future<bool> loadManagerPlayers() async {
    return await getHandler(http.Client(), '${url}gest/${hqpP!.userId}');
  }
  // coverage:ignore-end
  // ---------------------------------------------------------

  // CREATE
  Future<bool> postPlayer(http.Client client, Player value) async {
    loading = true;
    _result = false;

    try {
      var compressedBody = GZipCodec().encode(jsonEncode(value).codeUnits);
      final res = await client.post(
        Uri.parse(url),
        headers: _headersZip,
        body: compressedBody,
      );

      if (res.statusCode == 201) {
        final resJson = jsonDecode(res.body);
        final singlePlayer =
            Player.fromJson(resJson); // contiene solo 1 elemento
        hqpP!.addPlayerItem(singlePlayer);
        _result = true;
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }
  // ---------------------------------------------------------

  // UPDATE

  Future<bool> putPlayer(http.Client client, Player value, int index) async {
    loading = true;
    _result = false;

    final compressedBody =
        GZipCodec().encode(jsonEncode(hqpP!.player).codeUnits);

    try {
      final res = await client.put(
        Uri.parse('$url${hqpP!.player[index].bid}'),
        headers: _headersZip,
        body: compressedBody,
      );

      if (res.statusCode == 200) {
        hqpP!.editPlayerItem(value, index);
        _result = true;
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }
  // ---------------------------------------------------------

  // DELETE
  Future<bool> deletePlayer(http.Client client, int index) async {
    loading = true;
    _result = false;
    final bid = hqpP!.player[index].bid;
    try {
      final res = await client.delete(
        Uri.parse('$url$bid'),
        headers: _header,
      );

      if (res.statusCode == 200) {
        hqpP!.removePlayerItem(index);
        _result = true;
      }
    } catch (e) {
      // ...
    } finally {
      loading = false;
    }

    return _result;
  }
  // ---------------------------------------------------------
}
