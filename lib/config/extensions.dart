import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension MillisecondsToDate on int {
  Future<String> convertToVoteTime() async {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);

    if (date.hour > 4 && date.hour < 13) {
      return 'morning';
    } else if (date.hour > 11 && date.hour < 18) {
      return 'noon';
    } else if (date.hour > 16 && date.hour < 22) {
      return 'evening';
    } else {
      return 'night';
    }
  }
}
