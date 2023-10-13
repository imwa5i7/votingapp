// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisneyCharacter _$DisneyCharacterFromJson(Map<String, dynamic> json) =>
    DisneyCharacter(
      id: json['char-id'] as String?,
      name: json['char-name'] as String?,
      desc: json['char-desc'] as String?,
      slug: json['char-slug'] as String?,
      image: json['char-image'] as String?,
      vote: json['char-votes'] as int?,
      morningVotes: json['morning-votes'] ?? 0,
      nightVotes: json['night-votes'] ?? 0,
      eveningVotes: json['evening-votes'] ?? 0,
      noonVotes: json['noon-votes'] ?? 0,
      timestamp: json['creation-date'] as int?,
    );

Map<String, dynamic> _$DisneyCharacterToJson(DisneyCharacter instance) =>
    <String, dynamic>{
      'char-id': instance.id,
      'char-name': instance.name,
      'char-desc': instance.desc,
      'char-slug': instance.slug,
      'char-image': instance.image,
      'char-votes': instance.vote,
      'morning-votes': instance.morningVotes,
      'noon-votes': instance.noonVotes,
      'evening-votes': instance.eveningVotes,
      'night-votes': instance.nightVotes,
      'creation-date': instance.timestamp,
    };

CharacterVoting _$CharacterVotingFromJson(Map<String, dynamic> json) =>
    CharacterVoting(
      id: json['id'] as String?,
      name: json['char-name'] as String?,
      charId: json['char-id'] as String?,
      vote: json['char-votes'] as int?,
      voteTime: json['vote-time'] as String?,
      timestamp: json['creation-date'] as int?,
    );

Map<String, dynamic> _$CharacterVotingToJson(CharacterVoting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'char-id': instance.charId,
      'char-name': instance.name,
      'char-votes': instance.vote,
      'vote-time': instance.voteTime,
      'creation-date': instance.timestamp,
    };
