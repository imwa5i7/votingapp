import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/base_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:flutter/material.dart';

class VotingController extends BaseController {
  final Repository _repository;
  VotingController(this._repository);
  VotingRequest _request = VotingRequest(
      '', '', 0, AddCharacterRequest('', '', '', '', 0, 0, 0, 0, 0, 0));
  int _timestamp = DateTime.now().millisecondsSinceEpoch;
  List<Voting> allVotingList = [];
  List<Voting> currenVotingList = [];
  List<Voting> top5 = [];

  Voting? morning;
  Voting? noon;
  Voting? evening;
  Voting? night;

  DateTime? selectDateTime;

  _setValues(String id) async {
    _request =
        _request.copyWith(id: _timestamp.toString(), timestamp: _timestamp);
    _request =
        _request.copyWith(character: _request.character.copyWith(id: id));
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

      currenVotingList
          .sort((b, a) => a.character!.vote!.compareTo(b.character!.vote!));
      _setTopFiveReport();

      _setPopularityReport();

      for (int i = 0; i < currenVotingList.length; i++) {
        log('${currenVotingList[i].character!.vote}:${currenVotingList[i].character!.name!}');
      }

      for (int i = 0; i < top5.length; i++) {
        log('${top5[i].character!.vote}=>${top5[i].character!.name!}');
      }

      setState(States.completed(allVotingList));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  setToAll() {
    currenVotingList = allVotingList;
    selectDateTime = null;
    notifyListeners();
  }

  _setTopFiveReport() {
    top5 = currenVotingList.length > 4
        ? groupBy(currenVotingList, (e) => e.character!.id)
            .values
            .map((e) => e.first)
            .toList()
            .sublist(0, 5)
        : [];
    log(top5.length.toString(), name: 'Top 5');
  }

  _setPopularityReport() {
    morning = currenVotingList.isEmpty ? null : currenVotingList[0];
    noon = currenVotingList.isEmpty ? null : currenVotingList[0];
    evening = currenVotingList.isEmpty ? null : currenVotingList[0];
    night = currenVotingList.isEmpty ? null : currenVotingList[0];
    log(top5.length.toString(), name: 'Top 5');
    for (var i = 0; i < currenVotingList.length; i++) {
      if (currenVotingList[i].character!.morningVotes! >
          morning!.character!.morningVotes!) {
        morning = currenVotingList[i];
      }
      if (currenVotingList[i].character!.noonVotes! >
          noon!.character!.noonVotes!) {
        noon = currenVotingList[i];
      }
      if (currenVotingList[i].character!.eveningVotes! >
          evening!.character!.eveningVotes!) {
        evening = currenVotingList[i];
      }
      if (currenVotingList[i].character!.nightVotes! >
          night!.character!.nightVotes!) {
        night = currenVotingList[i];
      }
    }
  }

  filerListByCurrentDate(BuildContext context) async {
    selectDateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030));
    if (selectDateTime != null) {
      currenVotingList = allVotingList
          .where((element) =>
              _compareDates(element.timestamp!.toDate(), selectDateTime))
          .toList();
      log(currenVotingList.length.toString(), name: 'Filter List');
      _setTopFiveReport();
      _setPopularityReport();
    } else {
      currenVotingList = allVotingList;
      selectDateTime = null;
      _setTopFiveReport();
      _setPopularityReport();
    }
    notifyListeners();
  }

  bool _compareDates(DateTime a, b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
