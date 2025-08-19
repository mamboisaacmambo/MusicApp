import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/library_page.dart';
import 'package:client/features/home/view/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final List<Widget> pages = [const SongsPage(), const LibraryPage()];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final currentSong = ref.watch(currentSongNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(child: pages[selectedIndex]),

          // Music Slab (positioned above content but below navbar)
          if (currentSong != null)
            Positioned(
              bottom: 0, // Above the bottom nav bar
              left: 0,
              right: 0,
              child: const MusicSlab(),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Pallete.borderColor, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: Pallete.whiteColor,
        unselectedItemColor: Pallete.inactiveBottomBarItemColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                'assets/images/home_unfilled.png',
                width: 24,
                height: 24,
                color:
                    selectedIndex == 0
                        ? Pallete.whiteColor
                        : Pallete.inactiveBottomBarItemColor,
              ),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                'assets/images/home_filled.png',
                width: 24,
                height: 24,
                color: Pallete.whiteColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                'assets/images/library.png',
                width: 24,
                height: 24,
                color:
                    selectedIndex == 1
                        ? Pallete.whiteColor
                        : Pallete.inactiveBottomBarItemColor,
              ),
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
