import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  final Future<SharedPreferencesWithCache> _sharedPreferences =
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          // This cache will only accept the key 'counter'.
          allowList: <String>{'x-auth-token'},
        ),
      );

  void setToken(String? token) async {
    if (token != null) {
      final SharedPreferencesWithCache _prefs = await _sharedPreferences;
      _prefs.setString('x-auth-token', token);
    }
  }

  Future<String?> getToken() async {
    final SharedPreferencesWithCache _prefs = await _sharedPreferences;
    return _prefs.getString('x-auth-token');
  }
}
