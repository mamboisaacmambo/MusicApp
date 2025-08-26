import 'package:client/features/auth/model/user_model.dart';
import 'package:hive/hive.dart';
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
  final box = Hive.box<UserModel>('user');
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

  void addUserDetails(UserModel user) {
    box.put(user.id, user);
  }

  List<UserModel> getLocalUser() {
    List<UserModel> users = [];
    for (final key in box.keys) {
      users.add(UserModel.fromJson(box.get(key)!.toJson()));
    }
    return users;
  }
}
