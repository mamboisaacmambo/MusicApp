import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  void dispose() {
    Hive.box('songs').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final recentPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration:
          currentSong == null
              ? null
              : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    hexToColor(currentSong.hex_code),
                    Pallete.transparentColor,
                  ],
                  stops: [0.0, 0.2],
                ),
              ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recently Played Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // 4% of screen width
                vertical: screenHeight * 0.02, // 2% of screen height
              ),
              child: SizedBox(
                height: screenHeight * 0.35, // 35% of screen height
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (screenWidth / 2 - 24) / 80,
                    // Calculated based on available width
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: recentPlayedSongs.length,
                  itemBuilder: (context, index) {
                    final song = recentPlayedSongs[index];
                    return GestureDetector(
                      onTap:
                          () => ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Pallete.borderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Thumbnail
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(song.thumbnail_url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02), // 2% spacing
                            // Song Info
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.song_name,
                                      style: TextStyle(
                                        fontSize:
                                            screenWidth *
                                            0.035, // 3.5% of width
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      song.artist,
                                      style: TextStyle(
                                        fontSize:
                                            screenWidth * 0.03, // 3% of width
                                        color: Pallete.subtitleText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Latest Today Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              child: Text(
                "Latest Today",
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // 6% of width
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Horizontal Song List
            SizedBox(
              height: screenHeight * 0.28, // 28% of screen height
              child: ref
                  .watch(getAllSongsProvider)
                  .when(
                    data:
                        (songs) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return GestureDetector(
                              onTap:
                                  () => ref
                                      .read(
                                        currentSongNotifierProvider.notifier,
                                      )
                                      .updateSong(song),
                              child: Container(
                                width: screenWidth * 0.4, // 40% of screen width
                                margin: EdgeInsets.only(
                                  left: index == 0 ? screenWidth * 0.04 : 10,
                                  right:
                                      index == songs.length - 1
                                          ? screenWidth * 0.04
                                          : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Thumbnail
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              song.thumbnail_url,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    // Song Name
                                    Text(
                                      song.song_name,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    // Artist
                                    Text(
                                      song.artist,
                                      style: TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    error:
                        (error, st) => Center(
                          child: Text(
                            "Error: $error",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                    loading: () => const Loader(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
