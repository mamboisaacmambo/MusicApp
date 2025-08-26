import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/upload_song_page.dart';
import 'package:client/features/home/view_model/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final fav_songs = ref.watch(getAllFavSongsProvider);
    return ref
        .watch(getAllFavSongsProvider)
        .when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UploadSongPage();
                            },
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 35,
                        child: Icon(CupertinoIcons.plus),
                      ),
                      title: Text(
                        'Upload New Song',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }
                final song = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ListTile(
                    onTap: () {
                      ref
                          .read(currentSongNotifierProvider.notifier)
                          .updateSong(song);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(song.thumbnail_url),
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                    ),
                    title: Text(
                      song.song_name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: song.id);
                      },
                      icon: Icon(Icons.favorite_border),
                    ),
                  ),
                );
              },
            );
          },
          error: (error, st) {
            return Center(child: Text(error.toString()));
          },
          loading: () => Loader(),
        );
  }
}
