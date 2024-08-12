import 'package:hqitaapp/components/action_button.dart';
import 'package:hqitaapp/components/playerpage/player_container.dart';
import 'package:hqitaapp/components/playerpage/player_subtitle.dart';
import 'package:hqitaapp/components/playerpage/player_title.dart';
import 'package:hqitaapp/components/simple_button.dart';
import 'package:hqitaapp/constants.dart' show circleProgressColor;
import 'package:hqitaapp/models/player_index.dart';
import 'package:hqitaapp/models/player_model.dart';
import 'package:hqitaapp/providers/hqplayer_provider.dart';
import 'package:hqitaapp/providers/fav_provider.dart';
import 'package:hqitaapp/providers/http_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Color,
        Column,
        Icons,
        MainAxisAlignment,
        ModalRoute,
        Navigator,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SingleChildScrollView,
        SizedBox,
        StatelessWidget,
        UniqueKey,
        Widget,
        WillPopScope;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class PlayerPage extends StatelessWidget {
  static const String id = 'player_screen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlayerIndex;
    final hqplayerP = context.read<HQPlayerProvider>();
    final httpP = context.read<HttpProvider>();
    final favP = context.watch<FavProvider>();
    final userId = context
        .select<HQPlayerProvider, String>((hqplayerP) => hqplayerP.userId);
    final player = context.select<HQPlayerProvider, Player>(
        (hqplayerP) => hqplayerP.player[args.index]);
    final loading = context.select<HttpProvider, bool>((http) => http.loading);
    return WillPopScope(
      onWillPop: () async {
        context.read<FavProvider>().loadFavList();
        return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: loading,
        progressIndicator: circleProgressColor,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              if (userId != player.pid)
                ActionIconButton(
                  key: UniqueKey(),
                  icon: (player.fav) ? Icons.favorite : Icons.favorite_outline,
                  onPressed: () {
                    (player.fav)
                        ? favP.delFav(player.pid)
                        : favP.addFav(args.index);
                  },
                )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                PlayerTitle(title: player.name),
                const SizedBox(height: 5.0),
                PlayerSubTitle(),
                Row(
                  children: [
                    PlayerContainer(
                      onPressed: () => hqplayerP.openMap(args.index),
                      title: 'player_position'.tr(),
                      icon: Icons.location_on,
                      colour: const Color(0xFF2196F3),
                      info: 'player_openmap'.tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SimpleButton(
                  title: 'player_call'.tr(),
                  onPressed: () async => await hqplayerP.callNumber(args.index),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
