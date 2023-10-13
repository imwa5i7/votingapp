import 'dart:io';

class SignUpRequest {
  final String displayName, email, password;
  final int timestamp;
  SignUpRequest(this.displayName, this.email, this.password, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      'display-name': displayName,
      'email': email,
      'creation-date': timestamp,
    };
  }
}

class SignInRequest {
  final String email, password;
  SignInRequest(this.email, this.password);
}

class AddCharacterRequest {
  final String id;
  String image;
  final String name, desc;
  final int votes, timestamp;

  AddCharacterRequest(
      this.id, this.image, this.name, this.desc, this.votes, this.timestamp);

  AddCharacterRequest copyWith(
      {String? id,
      String? image,
      String? name,
      String? desc,
      int? votes,
      int? timestamp}) {
    return AddCharacterRequest(
        id ?? this.id,
        image ?? this.image,
        name ?? this.name,
        desc ?? this.desc,
        votes ?? this.votes,
        timestamp ?? this.timestamp);
  }

  Map<String, dynamic> toMap() {
    return {
      'char-id': id,
      'char-name': name,
      'char-desc': desc,
      'char-slug': name.toLowerCase().replaceAll(' ', '-').toString(),
      'char-image': image,
      'char-votes': votes,
      'creation-date': timestamp,
    };
  }
}

class VotingRequest {
  final String id;
  final String charId;
  final String charName;
  final int charVotes;
  final String voteTime;
  final int timestamp;
  VotingRequest(this.id, this.charId, this.charName, this.charVotes,
      this.voteTime, this.timestamp);

  VotingRequest copyWith(
      {String? id,
      String? charId,
      String? charName,
      String? voteTime,
      int? charVotes,
      int? timestamp}) {
    return VotingRequest(
        id ?? this.id,
        charId ?? this.charId,
        charName ?? this.charName,
        charVotes ?? this.charVotes,
        voteTime ?? this.voteTime,
        timestamp ?? this.timestamp);
  }

  Map<String, dynamic> toMap() {
    return {
      'voter-id': id,
      'char-id': charId,
      'char-name': charName,
      'char-votes': charVotes,
      'vote-time': voteTime,
      'creation-date': timestamp,
    };
  }
}
