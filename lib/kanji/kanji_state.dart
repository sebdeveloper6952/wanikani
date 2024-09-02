part of 'kanji_bloc.dart';

enum KanjiStatus {
  initial,
  loading,
  ready,
  waitingForMeaning,
  answerMeaningCorrect,
  waitingForWriting,
  answerWritingCorrect,
  incorrectAnswer,
  showingDetails,
  done,
  error,
}

class KanjiState extends Equatable {
  final KanjiStatus status;
  final Subject? subject;
  final String meaningGuess;

  const KanjiState({
    required this.status,
    required this.subject,
    required this.meaningGuess,
  });

  static KanjiState initial() => const KanjiState(
        status: KanjiStatus.loading,
        subject: null,
        meaningGuess: "",
      );

  KanjiState copyWith({
    KanjiStatus? status,
    Subject? subject,
    String? meaningGuess,
  }) =>
      KanjiState(
        status: status ?? this.status,
        subject: subject ?? this.subject,
        meaningGuess: meaningGuess ?? this.meaningGuess,
      );

  @override
  List<Object?> get props => [
        status,
        subject,
        meaningGuess,
      ];
}
