import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Field position printed on a player's sticker.
enum PlayerPosition { goalkeeper, defender, midfielder, forward }

extension PlayerPositionLabel on PlayerPosition {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PlayerPosition.goalkeeper:
        return l10n.positionGoalkeeper;
      case PlayerPosition.defender:
        return l10n.positionDefender;
      case PlayerPosition.midfielder:
        return l10n.positionMidfielder;
      case PlayerPosition.forward:
        return l10n.positionForward;
    }
  }
}
