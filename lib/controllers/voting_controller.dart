import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/base_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/data/requests/requests.dart';

class VotingController extends BaseController {
  final Repository _repository;
  VotingController(this._repository);
  VotingRequest _request = VotingRequest('', '', '', 0, '', 0);
  int _timestamp = DateTime.now().millisecondsSinceEpoch;

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
}
