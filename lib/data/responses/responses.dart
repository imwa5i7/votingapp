import 'package:freezed_annotation/freezed_annotation.dart';
part 'responses.g.dart';

@JsonSerializable()
class DisneyCharacter {
  @JsonKey(name: 'char-id')
  final String? id;
  @JsonKey(name: 'char-name')
  final String? name;
  @JsonKey(name: 'char-desc')
  final String? desc;
  @JsonKey(name: 'char-image')
  final String? image;
  @JsonKey(name: 'char-votes')
  final int? vote;
  @JsonKey(name: 'morning-votes')
  final int? morningVotes;
  @JsonKey(name: 'noon-votes')
  final int? noonVotes;
  @JsonKey(name: 'evening-votes')
  final int? eveningVotes;
  @JsonKey(name: 'night-votes')
  final int? nightVotes;
  @JsonKey(name: 'creation-date')
  final int? timestamp;
  @JsonKey(name: 'total-votes')
  final List<Voting>? totalVotes;

  DisneyCharacter({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.vote,
    this.morningVotes,
    this.nightVotes,
    this.eveningVotes,
    this.noonVotes,
    this.timestamp,
    this.totalVotes,
  });

  factory DisneyCharacter.fromJson(Map<String, dynamic> json) =>
      _$DisneyCharacterFromJson(json);
}

@JsonSerializable()
class Voting {
  @JsonKey(name: 'voter-id')
  final String? id;
  @JsonKey(name: 'char-id')
  final String? charId;
  @JsonKey(name: 'vote-time')
  final String? voteTime;
  @JsonKey(name: 'creation-date')
  final int? timestamp;
  Voting({this.id, this.charId, this.voteTime, this.timestamp});

  factory Voting.fromJson(Map<String, dynamic> json) => _$VotingFromJson(json);
}
