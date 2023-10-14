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
  final int morningVotes, noonVotes, eveningVotes, nightVotes;
  final int votes, timestamp;

  AddCharacterRequest(
      this.id,
      this.image,
      this.name,
      this.desc,
      this.votes,
      this.morningVotes,
      this.noonVotes,
      this.eveningVotes,
      this.nightVotes,
      this.timestamp);

  AddCharacterRequest copyWith(
      {String? id,
      String? image,
      String? name,
      String? desc,
      int? votes,
      int? morningVotes,
      int? noonVotes,
      int? eveningVotes,
      int? nightVotes,
      int? timestamp}) {
    return AddCharacterRequest(
        id ?? this.id,
        image ?? this.image,
        name ?? this.name,
        desc ?? this.desc,
        votes ?? this.votes,
        morningVotes ?? this.morningVotes,
        noonVotes ?? this.noonVotes,
        eveningVotes ?? this.eveningVotes,
        nightVotes ?? this.nightVotes,
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
      'morning-votes': morningVotes,
      'noon-votes': noonVotes,
      'evening-votes': eveningVotes,
      'night-votes': nightVotes,
      'creation-date': timestamp,
    };
  }
}

class VotingRequest {
  final String id;
  final String voteTime;
  final int timestamp;
  final AddCharacterRequest character;
  VotingRequest(this.id, this.voteTime, this.timestamp, this.character);

  VotingRequest copyWith({
    String? id,
    String? voteTime,
    int? timestamp,
    AddCharacterRequest? character,
  }) {
    return VotingRequest(
      id ?? this.id,
      voteTime ?? this.voteTime,
      timestamp ?? this.timestamp,
      character ?? this.character,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'voter-id': id,
      'vote-time': voteTime,
      'creation-date': timestamp,
      'character': character.toMap(),
    };
  }
}
