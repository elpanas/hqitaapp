import 'package:hqitaapp/components/action_button.dart';
import 'package:hqitaapp/components/playerlistpage/player_alert.dart';
import 'package:hqitaapp/components/playerlistpage/player_card.dart';
import 'package:hqitaapp/components/message.dart';
import 'package:hqitaapp/components/snackbar.dart';
import 'package:hqitaapp/constants.dart'
    show circleProgressColor, kAppBarTextStyle, kTitleListStyle;
import 'package:hqitaapp/models/player_index.dart';
import 'package:hqitaapp/models/player_model.dart';
import 'package:hqitaapp/providers/hqplayer_provider.dart';
import 'package:hqitaapp/providers/fav_provider.dart';
import 'package:hqitaapp/providers/http_provider.dart';
import 'package:hqitaapp/views/player_page.dart';
import 'package:hqitaapp/views/fav_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Column,
        Expanded,
        Icons,
        ListView,
        Navigator,
        Scaffold,
        ScaffoldMessenger,
        SizedBox,
        StatelessWidget,
        Text,
        UniqueKey,
        Widget,
        showDialog;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class PlayerListPage extends StatelessWidget {
  static const String id = 'player_list_screen';
  @override
  Widget build(BuildContext context) {
    final message = context
        .select<HQPlayerProvider, String>((hqplayerP) => hqplayerP.message);
    final playerCount = context
        .select<HQPlayerProvider, int>((hqplayerP) => hqplayerP.playerCount);
    final playerList = context.select<HQPlayerProvider, List<Player>>(
        (hqplayerP) => hqplayerP.player);
    final userId = context
        .select<HQPlayerProvider, String>((hqplayerP) => hqplayerP.userId);
    final httpP = context.read<HttpProvider>();
    final favP = context.read<FavProvider>();
    final loading = context.select<HttpProvider, bool>((http) => http.loading);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'player_list_title',
          style: kAppBarTextStyle,
        ).tr(),
        actions: [
          if (userId != '')
            ActionIconButton(
              key: UniqueKey(),
              icon: Icons.admin_panel_settings,
              onPressed: () => httpP.loadManagerPlayers(),
            ),
          ActionIconButton(
            key: UniqueKey(),
            icon: Icons.list,
            onPressed: () {
              favP.loadFavList();
              Navigator.pushNamed(context, FavListPage.id);
            },
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        progressIndicator: circleProgressColor,
        child: SizedBox(
          width: double.infinity,
          child: (playerList.isNotEmpty)
              ? Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      playerList[0].city,
                      style: kTitleListStyle,
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: playerCount,
                        itemBuilder: (context, index) {
                          return PlayerCard(
                            key: UniqueKey(),
                            title: playerList[index].name,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PlayerPage.id,
                                arguments: PlayerIndex(index: index),
                              );
                            },
                            onLongPress: () {
                              if (userId != '') {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return DeleteAlert(
                                      onPressed: () async {
                                        bool result = await httpP.deletePlayer(
                                            http.Client(), index);
                                        if (result) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBarBuilder(
                                              title: 'player_deleted'.tr(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              }
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
    );
  }
}
