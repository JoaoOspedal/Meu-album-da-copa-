import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Field position printed on a player's sticker.
enum PlayerPosition { goalkeeper, defender, midfielder, forward }

/// Maps the backend position code (GK/DF/MF/FW) to a [PlayerPosition].
/// Unknown/null codes fall back to [PlayerPosition.midfielder].
PlayerPosition playerPositionFromCode(String? code) {
  switch (code?.toUpperCase()) {
    case 'GK':
      return PlayerPosition.goalkeeper;
    case 'DF':
      return PlayerPosition.defender;
    case 'FW':
      return PlayerPosition.forward;
    case 'MF':
      return PlayerPosition.midfielder;
    default:
      return PlayerPosition.midfielder;
  }
}

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
