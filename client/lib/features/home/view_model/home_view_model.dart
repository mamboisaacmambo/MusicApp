import 'dart:io';
import 'dart:ui';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncLoading();
    print("In HomeViewModel uploadSong");
    final res = await _homeRepository.uploadSong(
      song_name: songName,
      artist: artist,
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    print(val);
  }
}
