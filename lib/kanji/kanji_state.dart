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
  final List<String> writingGuesses;

  const KanjiState({
    required this.status,
    required this.subject,
    required this.meaningGuess,
    required this.writingGuesses,
  });

  static KanjiState initial() => const KanjiState(
        status: KanjiStatus.loading,
        subject: null,
        meaningGuess: "",
        writingGuesses: [],
      );

  KanjiState copyWith({
    KanjiStatus? status,
    Subject? subject,
    String? meaningGuess,
    List<String>? writingGuesses,
  }) =>
      KanjiState(
        status: status ?? this.status,
        subject: subject ?? this.subject,
        meaningGuess: meaningGuess ?? this.meaningGuess,
        writingGuesses: writingGuesses ?? this.writingGuesses,
      );

  @override
  List<Object?> get props => [
        status,
        subject,
        meaningGuess,
      ];
}
