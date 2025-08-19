import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerStatefulWidget {
  const MusicSlab({super.key});

  @override
  ConsumerState<MusicSlab> createState() => _MusicSlabState();
}

class _MusicSlabState extends ConsumerState<MusicSlab> {
  @override
  Widget build(BuildContext context) {
    final current_song = ref.watch(currentSongNotifierProvider);
    final song_notifier = ref.read(currentSongNotifierProvider.notifier);
    bool isPressed = false;
    if (current_song == null) {
      return SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MusicPlayer()),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: 'music-image',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hexToColor(current_song.hex_code),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 66,
              width: MediaQuery.of(context).size.width - 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(current_song.thumbnail_url),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current_song.song_name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            current_song.artist,
                            style: TextStyle(
                              fontSize: 14,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return IconButton(
                            icon:
                                isPressed == true
                                    ? Icon(
                                      Icons.favorite,
                                      color: Pallete.whiteColor,
                                    )
                                    : Icon(Icons.favorite_border),
                            onPressed: () {
                              // Handle skip previous action
                              setState(() {
                                isPressed = !isPressed;
                              });
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          song_notifier.isPlaying == true
                              ? Icons.pause_circle
                              : Icons.play_arrow,
                          color: Pallete.whiteColor,
                        ),
                        onPressed: () {
                          song_notifier.playPause();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: song_notifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }
              final position = snapshot.data ?? Duration.zero;
              final duration =
                  song_notifier.audioPlayer?.duration ?? Duration.zero;
              double sliderValue = 0.0;
              if (position != Duration.zero && duration != Duration.zero) {
                sliderValue =
                    position.inMilliseconds.toDouble() /
                    duration.inMilliseconds.toDouble();
              }
              return Positioned(
                bottom: 0,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 16),
                  decoration: BoxDecoration(color: Pallete.whiteColor),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(color: Pallete.inactiveSeekColor),
            ),
          ),
        ],
      ),
    );
  }
}
