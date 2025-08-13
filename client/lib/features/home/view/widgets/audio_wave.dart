import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    try {
      await playerController.preparePlayer(
        path: widget.path,
        shouldExtractWaveform: true,
        volume: 1.0,
        noOfSamples: 100, // Reduce if having performance issues
      );
      setState(() {});
    } catch (e) {
      print("Error initializing audio player: $e");
    }
  }

  Future<void> playAndPauseAudio() async {
    print('Starting audio playback');
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer();
    } else if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
          onPressed: playAndPauseAudio,
        ),

        Expanded(
          child: AudioFileWaveforms(
            size: Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 6,
            ),
          ),
        ),
      ],
    );
  }
}
