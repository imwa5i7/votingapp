import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}

extension MillisecondsToDate on int {
  Future<String> convertToVoteTime() async {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);

    if (date.hour > 4 && date.hour <= 12) {
      return 'morning';
    } else if (date.hour >= 12 && date.hour <= 17) {
      return 'noon';
    } else if (date.hour >= 17 && date.hour <= 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }
}
