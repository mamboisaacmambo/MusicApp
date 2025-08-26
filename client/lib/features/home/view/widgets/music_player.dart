import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/view_model/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current_song = ref.watch(currentSongNotifierProvider);
    final song_notifier = ref.read(currentSongNotifierProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(current_song!.hex_code), Color(0xFF121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          title: Text(current_song?.song_name ?? 'Music Player'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Transform.translate(
              offset: const Offset(-15, 0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: LayoutBuilder(
          // Helps adjust UI based on available space
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Ensures content is scrollable if too long
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // Album Art (Responsive Height)
                    Container(
                      height: screenHeight * 0.4, // Takes 40% of screen height
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(current_song.thumbnail_url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Song Controls (Flexible)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Song Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      current_song.song_name,
                                      style: TextStyle(
                                        color: Pallete.whiteColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      current_song.artist,
                                      style: TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(homeViewModelProvider.notifier)
                                      .favSong(songId: current_song.id);
                                },
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Progress Bar
                          StreamBuilder(
                            stream: song_notifier.audioPlayer?.positionStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              final position =
                                  song_notifier.audioPlayer?.position;
                              final duration =
                                  song_notifier.audioPlayer?.duration ??
                                  Duration.zero;
                              double sliderValue = 0.0;
                              if (position != Duration.zero &&
                                  duration != Duration.zero) {
                                sliderValue =
                                    position!.inMilliseconds.toDouble() /
                                    duration.inMilliseconds.toDouble();
                              }
                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Pallete.whiteColor,
                                      inactiveTrackColor: Pallete
                                          .inactiveBottomBarItemColor
                                          .withOpacity(0.117),
                                      thumbColor: Pallete.whiteColor,
                                      trackHeight: 4.0,
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                    ),
                                    child: StatefulBuilder(
                                      builder:
                                          (context, setState) => Slider(
                                            value: sliderValue,
                                            min: 0,
                                            max: 1,
                                            onChanged: (value) {
                                              sliderValue = value;
                                              setState(() {});
                                            },
                                            onChangeEnd: (value) {
                                              song_notifier.seek(value);
                                            },
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${position?.inMinutes ?? 0}:${((position?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            color: Pallete.subtitleText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            color: Pallete.subtitleText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          // Music Controls (Adjusted for small screens)
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/shuffle.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/previus-song.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                onPressed: () => song_notifier.playPause(),
                                icon: Icon(
                                  song_notifier.isPlaying
                                      ? CupertinoIcons.pause_circle_fill
                                      : CupertinoIcons.play_circle_fill,
                                  color: Pallete.whiteColor,
                                  size: 50, // Reduced size for small screens
                                ),
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/next-song.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/repeat.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          // Bottom Row (Connect Device & Playlist)
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/connect-device.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/playlist.png',
                                  color: Pallete.whiteColor,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
