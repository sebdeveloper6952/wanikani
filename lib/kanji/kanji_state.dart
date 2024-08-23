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

  const KanjiState({
    required this.status,
    required this.subject,
  });

  static KanjiState initial() => const KanjiState(
        status: KanjiStatus.loading,
        subject: null,
      );

  KanjiState copyWith({
    KanjiStatus? status,
    Subject? subject,
  }) =>
      KanjiState(
        status: status ?? this.status,
        subject: subject ?? this.subject,
      );

  @override
  List<Object?> get props => [
        status,
        subject,
      ];
}
