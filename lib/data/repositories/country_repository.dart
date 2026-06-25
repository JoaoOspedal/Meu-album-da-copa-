import '../../models/country.dart';

/// Source of national teams taking part in the album.
///
/// Kept abstract so the UI never depends on where the data actually comes
/// from. Backed by `ApiCountryRepository`, which reads from the catalog loaded
/// from the backend.
abstract class CountryRepository {
  List<Country> getAllCountries();

  Country? getById(String id);
}
