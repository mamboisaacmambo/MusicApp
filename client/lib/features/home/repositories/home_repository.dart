import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required String song_name,
    required String artist,
    required File selectedAudio,
    required File selectedImage,
    required String hexCode,
    required String token,
  }) async {
    print('Uploading song: $song_name by $artist');
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverURL}/song/upload'),
      );
      request
        ..files.addAll([
          await http.MultipartFile.fromPath('audio', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'song_name': song_name,
          'artist': artist,
          'hex_code': hexCode, // Example color in hex format
        })
        ..headers.addAll({'x-auth-token': token});
      final res = await request.send();
      if (res.statusCode != 201) {
        final resBody = await res.stream.bytesToString();
        return Left(AppFailure(resBody));
      } else {
        return Right(await res.stream.bytesToString());
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
