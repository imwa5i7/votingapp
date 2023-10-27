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
      image: json['char-image'] as String?,
      vote: json['char-votes'] as int?,
      morningVotes: json['morning-votes'] as int?,
      nightVotes: json['night-votes'] as int?,
      eveningVotes: json['evening-votes'] as int?,
      noonVotes: json['noon-votes'] as int?,
      timestamp: json['creation-date'] as int?,
      totalVotes: json.containsKey('total-votes')
          ? (json['total-votes'] as List<dynamic>?)
              ?.map((e) => Voting.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );

Voting _$VotingFromJson(Map<String, dynamic> json) => Voting(
      id: json['voter-id'] as String?,
      charId: json['char-id'] as String?,
      voteTime: json['vote-time'] as String?,
      timestamp: json['creation-date'] as int?,
    );
