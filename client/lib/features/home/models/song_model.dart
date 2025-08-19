import 'dart:convert';

import 'package:hive/hive.dart';
part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String song_name;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String thumbnail_url;
  @HiveField(4)
  final String audio_url;
  @HiveField(5)
  final String hex_code;
  SongModel({
    required this.id,
    required this.song_name,
    required this.artist,
    required this.thumbnail_url,
    required this.audio_url,
    required this.hex_code,
  });

  SongModel copyWith({
    String? id,
    String? song_name,
    String? artist,
    String? thumbnail_url,
    String? audio_url,
    String? hex_code,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist: artist ?? this.artist,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      audio_url: audio_url ?? this.audio_url,
      hex_code: hex_code ?? this.hex_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'artist': artist,
      'thumbnail_url': thumbnail_url,
      'audio_url': audio_url,
      'hex_code': hex_code,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      song_name: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      audio_url: map['audio_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_name: $song_name, artist: $artist, thumbnail_url: $thumbnail_url, audio_url: $audio_url, hex_code: $hex_code)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_name == song_name &&
        other.artist == artist &&
        other.thumbnail_url == thumbnail_url &&
        other.audio_url == audio_url &&
        other.hex_code == hex_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        song_name.hashCode ^
        artist.hashCode ^
        thumbnail_url.hashCode ^
        audio_url.hashCode ^
        hex_code.hashCode;
  }
}
