import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/base_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:flutter/material.dart';

class VotingController extends BaseController {
  final Repository _repository;
  final FirebaseFirestore _firestore;
  VotingController(this._repository, this._firestore);
  VotingRequest _request = VotingRequest('', '', '', 0);
  int _timestamp = DateTime.now().millisecondsSinceEpoch;
  List<Voting> allVotingList = [];
  List<Voting> currenVotingList = [];

  List<DisneyCharacter> topFiveCharList = [];
  DisneyCharacter? morning;
  DisneyCharacter? noon;
  DisneyCharacter? evening;
  DisneyCharacter? night;

  DateTime? selectDateTime;

  _setValues(String id) async {
    _request =
        _request.copyWith(id: _timestamp.toString(), timestamp: _timestamp);
    _request = _request.copyWith(charId: id);
    _request =
        _request.copyWith(voteTime: await _timestamp.convertToVoteTime());
  }

  delayForSec() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  vote(String id) async {
    setState(States.loading(Constants.loading));
    await _setValues(id);
    final result = await _repository.vote(_request);
    if (result.isRight()) {
      _timestamp = DateTime.now().millisecondsSinceEpoch;
      setState(States.buttonLoading(Constants.loading));
      await Future.delayed(const Duration(seconds: 3));
      setState(States.completed(result.asRight()));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  getVotes() async {
    setState(States.loading(Constants.loading));
    final result = await _repository.getVotes();
    if (result.isRight()) {
      allVotingList = result.asRight();
      currenVotingList = allVotingList;

      // allVoting = voting;

      // voting
      //     .sort((b, a) => a.totalVotes!.length.compareTo(b.totalVotes!.length));

      // currenVotingList
      //     .sort((b, a) => a.character!.vote!.compareTo(b.character!.vote!));
      await _setTopFiveReport();

      await _setPopularityReport();

      // for (int i = 0; i < currenVotingList.length; i++) {
      //   log('${currenVotingList[i].character!.vote}:${currenVotingList[i].character!.name!}');
      // }

      // for (int i = 0; i < top5.length; i++) {
      //   log('${top5[i].character!.vote}=>${top5[i].character!.name!}');
      // }

      setState(States.completed(allVotingList));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  setToAll() async {
    setState(States.loading(Constants.loading));
    currenVotingList = allVotingList;
    await _setTopFiveReport();
    await _setPopularityReport();
    selectDateTime = null;
    setState(States.completed(allVotingList));

    notifyListeners();
  }

  int totalVotes = 0;

  List<MapEntry> _getTopFiveReport() {
    var map = {};

    for (var element in currenVotingList) {
      if (!map.containsKey(element.charId)) {
        map[element.charId] = 1;
      } else {
        map[element.charId] += 1;
      }
    }

    log(map.toString());
    List<MapEntry> sortedEntries = map.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });

    for (int i = 0; i < sortedEntries.length; i++) {
      log('${sortedEntries[i].key}=>${sortedEntries[i].value}');
    }

    return sortedEntries.length > 4 ? sortedEntries.sublist(0, 5) : [];
  }

  _setTopFiveReport() async {
    topFiveCharList = [];
    List<MapEntry> topFiveEntries = _getTopFiveReport();
    for (int i = 0; i < topFiveEntries.length; i++) {
      log('${topFiveEntries[i].key}=>${topFiveEntries[i].value}',
          name: 'Top Five');
    }

    for (int i = 0; i < topFiveEntries.length; i++) {
      await _firestore
          .collection(Constants.charRef)
          .doc(topFiveEntries[i].key)
          .update({
        'char-votes': topFiveEntries[i].value,
      });

      final result = await _repository.getCharactersById(topFiveEntries[i].key);
      if (result.isRight()) {
        topFiveCharList.add(result.asRight());
      } else {
        topFiveCharList = [];
      }
    }

    // for (int i = 0; i < topFiveCharList.length; i++) {
    //   log('${topFiveCharList[i].name}=>${topFiveCharList[i].vote}');
    // }
  }

  MapEntry? _getMostInTime(String time) {
    List<Voting> durationList =
        currenVotingList.where((element) => element.voteTime == time).toList();
    var map = {};
    for (var element in durationList) {
      if (!map.containsKey(element.charId)) {
        map[element.charId] = 1;
      } else {
        map[element.charId] += 1;
      }
    }

    List<MapEntry> sortedEntries = map.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });

    for (int i = 0; i < sortedEntries.length; i++) {
      log('${sortedEntries[i].key}=>${sortedEntries[i].value}',
          name: 'Duration $time');
    }

    return sortedEntries.isNotEmpty ? sortedEntries[0] : null;
  }

  Future<DisneyCharacter?> _getCharacterInTime(String time) async {
    MapEntry? timeEntry = _getMostInTime(time);
    if (timeEntry != null) {
      await _firestore.collection(Constants.charRef).doc(timeEntry.key).update({
        '$time-votes': timeEntry.value,
      });
      final result = await _repository.getCharactersById(timeEntry.key);
      if (result.isRight()) {
        return result.asRight();
      } else {
        return null;
      }
    }
    return null;
  }

  _setPopularityReport() async {
    morning = await _getCharacterInTime('morning');
    noon = await _getCharacterInTime('noon');
    evening = await _getCharacterInTime('evening');
    night = await _getCharacterInTime('night');
  }

  filerListByCurrentDate(BuildContext context) async {
    selectDateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030));
    if (selectDateTime != null) {
      setState(States.loading(Constants.loading));

      currenVotingList = allVotingList
          .where((element) =>
              _compareDates(element.timestamp!.toDate(), selectDateTime!))
          .toList();
      log(currenVotingList.length.toString(), name: 'Filter List');
      await _setTopFiveReport();
      await _setPopularityReport();
      setState(States.completed(allVotingList));
    } else {
      setState(States.loading(Constants.loading));
      currenVotingList = allVotingList;
      selectDateTime = null;
      await _setTopFiveReport();
      await _setPopularityReport();
      setState(States.completed(allVotingList));
    }
    notifyListeners();
  }

  bool _compareDates(DateTime a, b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
