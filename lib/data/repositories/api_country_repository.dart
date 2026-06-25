import '../../models/country.dart';
import '../catalog_store.dart';
import 'country_repository.dart';

/// [CountryRepository] backed by the catalog loaded from the backend.
class ApiCountryRepository implements CountryRepository {
  ApiCountryRepository(this._store);

  final CatalogStore _store;

  @override
  List<Country> getAllCountries() => _store.countries;

  @override
  Country? getById(String id) => _store.countryById(id);
}
