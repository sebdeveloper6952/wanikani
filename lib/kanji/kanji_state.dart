part of 'kanji_bloc.dart';

enum KanjiStatus {
  initial,
  loading,
  ready,
  waitingForMeaning,
  answerMeaningCorrect,
  waitingForReading,
  answerReadingCorrect,
  incorrectAnswer,
  showingDetails,
  done,
  error,
}

class KanjiState extends Equatable {
  final KanjiStatus status;
  final Subject? subject;
  final String meaningGuess;
  final List<String> readingGuesses;

  const KanjiState({
    required this.status,
    required this.subject,
    required this.meaningGuess,
    required this.readingGuesses,
  });

  static KanjiState initial() => const KanjiState(
        status: KanjiStatus.loading,
        subject: null,
        meaningGuess: "",
        readingGuesses: [],
      );

  KanjiState copyWith({
    KanjiStatus? status,
    Subject? subject,
    String? meaningGuess,
    List<String>? readingGuesses,
  }) =>
      KanjiState(
        status: status ?? this.status,
        subject: subject ?? this.subject,
        meaningGuess: meaningGuess ?? this.meaningGuess,
        readingGuesses: readingGuesses ?? this.readingGuesses,
      );

  @override
  List<Object?> get props => [
        status,
        subject,
        meaningGuess,
      ];
}
