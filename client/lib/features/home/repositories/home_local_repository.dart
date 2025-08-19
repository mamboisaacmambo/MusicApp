import 'package:client/features/home/models/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final box = Hive.box<SongModel>('songs');
  void uploadLocalSong(SongModel song) {
    box.put(song.id, song);
    print('Song uploaded locally: ${song.song_name}');
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)!.toJson()));
    }

    return songs; // Return the actual songs list, not an empty list
  }
}
