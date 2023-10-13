import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../config/config.dart';

abstract class Repository {
  Future<Either<String, User>> signIn(SignInRequest request);
  Future<Either<String, User>> signUp(SignUpRequest request);
  Future<Either<String, String>> signOut();
  Future<Either<String, String>> addCharacter(
      AddCharacterRequest request, File? image, String id, String? myImage);
  Future<String?> addImage(File image);
  Future<Either<String, List<DisneyCharacter>>> getCharacters();
  Future<Either<String, DisneyCharacter>> getCharactersById(String id);
  Future<Either<String, String>> vote(VotingRequest request);
  Future<Either<String, String>> resetPassword(String email);
}

class RepoImpl implements Repository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  RepoImpl(this._auth, this._firestore, this._storage);

  @override
  Future<Either<String, User>> signIn(SignInRequest request) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: request.email, password: request.password);
      if (credential.user != null) {
        return Right(credential.user!);
      } else {
        return const Left('Error Signing in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Wrong password provided for that user.');
      } else {
        return Left(e.message.toString());
      }
    } catch (err) {
      print(err);
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, User>> signUp(SignUpRequest request) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: request.email, password: request.password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(request.displayName);
        await _firestore
            .collection(Constants.adminRef)
            .doc(request.timestamp.toString())
            .set(request.toMap());

        return Right(credential.user!);
      } else {
        return const Left('Error Signing up');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const Left('The account already exists for that email.');
      } else {
        return Left(e.message.toString());
      }
    } catch (err) {
      print(err);
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, String>> signOut() async {
    try {
      await _auth.signOut();
      return const Right('Sign-out Successfully');
    } catch (err) {
      print(err);
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, String>> addCharacter(AddCharacterRequest request,
      File? image, String? id, String? myImage) async {
    if (id != null) {
      log(id);
      request = request.copyWith(id: id, timestamp: int.parse(id!));
    }
    String? url = image == null ? myImage : await addImage(image);
    if (url != null) {
      request = request.copyWith(image: url);
      try {
        await _firestore
            .collection(Constants.charRef)
            .doc(request.id)
            .set(request.toMap());
        return const Right('Character Added Successfully');
      } catch (err) {
        return Left(err.toString());
      }
    } else {
      log('Url is empty');

      return const Left('Url is Empty');
    }
  }

  @override
  Future<String?> addImage(File image) async {
    String? imageUrl;
    try {
      final UploadTask task = _storage
          .ref('character_images')
          .child('char_${DateTime.now().millisecondsSinceEpoch}.jpg')
          .putFile(image);

      await task.then((p0) async {
        imageUrl = await p0.ref.getDownloadURL();
      }).catchError((err) {
        throw err;
      });
      return imageUrl;
    } on FirebaseException catch (err) {
      return null;
    }
  }

  @override
  Future<Either<String, List<DisneyCharacter>>> getCharacters() async {
    List<DisneyCharacter> charList = [];

    try {
      QuerySnapshot snapshots =
          await _firestore.collection(Constants.charRef).get();
      for (int i = 0; i < snapshots.docs.length; i++) {
        DisneyCharacter character = DisneyCharacter.fromJson(
            snapshots.docs[i].data() as Map<String, dynamic>);
        charList.add(character);
      }

      return Right(charList);
    } catch (err) {
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, DisneyCharacter>> getCharactersById(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection(Constants.charRef).doc(id).get();
      DisneyCharacter character =
          DisneyCharacter.fromJson(snapshot.data() as Map<String, dynamic>);
      return Right(character);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> vote(VotingRequest request) async {
    try {
      final result = await getCharactersById(request.charId);
      if (result.isRight()) {
        DisneyCharacter character = result.asRight();
        int vote = character.vote! + 1;

        int moringVotes = character.morningVotes!;
        int noonVotes = character.noonVotes!;
        int eveningVotes = character.eveningVotes!;
        int nightVotes = character.nightVotes!;

        if (request.voteTime == 'morning') {
          moringVotes == moringVotes + 1;
        } else if (request.voteTime == 'noon') {
          noonVotes = noonVotes + 1;
        } else if (request.voteTime == 'evening') {
          eveningVotes = eveningVotes + 1;
        } else {
          nightVotes = nightVotes + 1;
        }

        //update character votes
        await _firestore
            .collection(Constants.charRef)
            .doc(character.id)
            .update({
          'char-votes': vote,
          'morning-votes': moringVotes,
          'noon-votes': noonVotes,
          'evening-votes': eveningVotes,
          'night-votes': nightVotes,
        });
        //cast voting
        request = request.copyWith(charVotes: vote);
        request = request.copyWith(charName: character.name);
        await _firestore
            .collection(Constants.votingRef)
            .doc(request.id)
            .set(request.toMap());
        return Right('Voted for ${character.name} Successfully');
      } else {
        return const Left('Problem with voting');
      }
    } catch (err) {
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, String>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right('Check your Email!');
    } catch (err) {
      print(err);
      return Left(err.toString());
    }
  }
}
