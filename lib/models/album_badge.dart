import 'package:flutter/foundation.dart';

/// Badge/emblem sticker of a national team (figurinha de brasão), as opposed to
/// a player sticker. Belongs to a [Country] via [countryId].
@immutable
class AlbumBadge {
  final int stickerId;
  final int number;
  final String title;
  final String countryId;
  final String? imageUrl;

  const AlbumBadge({
    required this.stickerId,
    required this.number,
    required this.title,
    required this.countryId,
    this.imageUrl,
  });
}
