import '../../models/country.dart';

/// Source of national teams taking part in the album.
///
/// Kept abstract so the UI never depends on where the data actually comes
/// from. Today it's backed by [MockCountryRepository]; a future real API
/// repository could implement this same contract without touching any screen.
abstract class CountryRepository {
  List<Country> getAllCountries();

  Country? getById(String id);
}
