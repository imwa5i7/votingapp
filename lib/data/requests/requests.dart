class SignUpRequest {
  final String displayName, email, password;
  final int timestamp;
  SignUpRequest(this.displayName, this.email, this.password, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      'id': timestamp.toString(),
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
  final int timestamp;
  final List<VotingRequest> votingRequest;

  AddCharacterRequest(this.id, this.image, this.name, this.desc, this.timestamp,
      this.votingRequest);

  AddCharacterRequest copyWith(
      {String? id,
      String? image,
      String? name,
      String? desc,
      int? timestamp,
      List<VotingRequest>? votingRequest}) {
    return AddCharacterRequest(
      id ?? this.id,
      image ?? this.image,
      name ?? this.name,
      desc ?? this.desc,
      timestamp ?? this.timestamp,
      votingRequest ?? this.votingRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'char-id': id,
      'char-name': name,
      'char-desc': desc,
      'char-image': image,
      'creation-date': timestamp,
    };
  }
}

class VotingRequest {
  final String id;
  final String charId;
  final String voteTime;
  final int timestamp;

  VotingRequest(this.id, this.charId, this.voteTime, this.timestamp);

  VotingRequest copyWith({
    String? id,
    String? charId,
    String? voteTime,
    int? timestamp,
  }) {
    return VotingRequest(
      id ?? this.id,
      charId ?? this.charId,
      voteTime ?? this.voteTime,
      timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'voter-id': id,
      'char-id': charId,
      'vote-time': voteTime,
      'creation-date': timestamp,
    };
  }
}
