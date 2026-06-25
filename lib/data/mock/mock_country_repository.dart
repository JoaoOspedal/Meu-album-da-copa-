import '../../models/country.dart';
import '../repositories/country_repository.dart';
import 'mock_data.dart';

class MockCountryRepository implements CountryRepository {
  @override
  List<Country> getAllCountries() => MockData.countries;

  @override
  Country? getById(String id) {
    for (final country in MockData.countries) {
      if (country.id == id) return country;
    }
    return null;
  }
}
