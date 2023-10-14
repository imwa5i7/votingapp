import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/data/requests/requests.dart';

import 'base_controller.dart';

class AuthController extends BaseController {
  final Repository _repository;
  AuthController(this._repository);

  signUp(SignUpRequest request) async {
    setState(States.buttonLoading(Constants.loading));
    final result = await _repository.signUp(request);
    if (result.isRight()) {
      setState(States.completed(result.asRight()));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  signIn(SignInRequest request) async {
    setState(States.buttonLoading(Constants.loading));
    final result = await _repository.signIn(request);
    if (result.isRight()) {
      setState(States.completed(result.asRight()));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  updatePassword(String email) async {
    setState(States.buttonLoading(Constants.loading));
    final result = await _repository.updatePassword(email);
    if (result.isRight()) {
      setState(States.completed(result.asRight()));
    } else {
      setState(States.error(result.asLeft()));
    }
  }

  Future<bool> signOut() async {
    final result = await _repository.signOut();
    if (result.isRight()) {
      return true;
    } else {
      return false;
    }
  }
}
