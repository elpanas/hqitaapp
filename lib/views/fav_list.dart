import 'package:hqitaapp/components/playerlistpage/player_alert.dart';
import 'package:hqitaapp/components/favlistpage/fav_card.dart';
import 'package:hqitaapp/components/message.dart';
import 'package:hqitaapp/components/snackbar.dart';
import 'package:hqitaapp/constants.dart'
    show circleProgressColor, kAppBarTextStyle;
import 'package:hqitaapp/models/player_index.dart';
import 'package:hqitaapp/providers/fav_provider.dart';
import 'package:hqitaapp/providers/hqplayer_provider.dart';
import 'package:hqitaapp/providers/http_provider.dart';
import 'package:hqitaapp/views/player_page.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Column,
        Expanded,
        ListView,
        Navigator,
        Scaffold,
        ScaffoldMessenger,
        SizedBox,
        StatelessWidget,
        Text,
        UniqueKey,
        Widget,
        WillPopScope,
        showDialog;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: use_key_in_widget_constructors
class FavListPage extends StatelessWidget {
  static const String id = 'fav_list_screen';
  @override
  Widget build(BuildContext context) {
    final hqplayerP = context.read<HQPlayerProvider>();
    final httpP = context.read<HttpProvider>();
    final favP = context.read<FavProvider>();
    final loading = context.select<HttpProvider, bool>((http) => http.loading);
    final favPlayers =
        context.select<FavProvider, List<dynamic>>((favp) => favp.favList);
    final message = context
        .select<HQPlayerProvider, String>((hqplayerp) => hqplayerp.message);
    return WillPopScope(
      onWillPop: () async {
        if (hqplayerP.playerCount == 1) {
          httpP.loadPlayers();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'fav_list_title',
          style: kAppBarTextStyle,
        ).tr()),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          progressIndicator: circleProgressColor,
          child: SizedBox(
            width: double.infinity,
            child: (favPlayers.isNotEmpty)
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favPlayers.length,
                          itemBuilder: (context, index) {
                            return FavCard(
                              key: UniqueKey(),
                              title: favPlayers[index].name,
                              city: favPlayers[index].city,
                              onTap: () {
                                httpP.loadPlayer(favPlayers[index].bid);
                                Navigator.pushNamed(
                                  context,
                                  PlayerPage.id,
                                  arguments: PlayerIndex(
                                    index: 0,
                                    favIndex: index,
                                  ),
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return DeleteAlert(
                                      onPressed: () {
                                        favP.delFav(favPlayers[index].bid);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          snackBarBuilder(
                                              title: 'player_deleted'.tr()),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Message(message: message),
          ),
        ),
      ),
    );
  }
}
