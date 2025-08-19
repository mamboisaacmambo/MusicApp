import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    // Initialize state to null
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null; // Initial state is null
  }

  void updateSong(SongModel song) async {
    print('Updating current song: ${song.song_name}');
    await audioPlayer?.stop(); // Dispose previous player if exists
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.audio_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false; // Reset playing state when song complete
        audioPlayer?.seek(Duration.zero); // Reset to start
        audioPlayer?.pause(); // Pause the player

        this.state = this.state?.copyWith(
          hex_code: this.state?.hex_code,
        ); // Update state with new hex code
      }
    });
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true; // Set the playing state to true
    state = song; // Update the current song state
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    audioPlayer?.seek(
      Duration(
        milliseconds:
            (val * (audioPlayer?.duration?.inMilliseconds ?? 0)).toInt(),
      ),
    );
  }
}
