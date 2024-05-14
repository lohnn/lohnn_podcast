import 'package:flutter/material.dart';
import 'package:podcast/screens/modals/episode_player_modal.dart';

class PlayerModalNavigator extends StatelessWidget {
  const PlayerModalNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Navigator(
        onPopPage: (route, result) {
          route.didPop(result);
          return true;
        },
        pages: const [
          MaterialPage(child: EpisodePlayerModal()),
        ],
      ),
    );
  }
}
