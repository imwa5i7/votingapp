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
      morningVotes: json['morning-votes'] as int?,
      nightVotes: json['night-votes'] as int?,
      eveningVotes: json['evening-votes'] as int?,
      noonVotes: json['noon-votes'] as int?,
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

Voting _$CharacterVotingFromJson(Map<String, dynamic> json) => Voting(
      id: json['voter-id'] as String?,
      voteTime: json['vote-time'] as String?,
      timestamp: json['creation-date'] as int?,
      character: json['character'] == null
          ? null
          : DisneyCharacter.fromJson(json['character'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterVotingToJson(Voting instance) =>
    <String, dynamic>{
      'voter-id': instance.id,
      'vote-time': instance.voteTime,
      'creation-date': instance.timestamp,
      'character': instance.character,
    };
