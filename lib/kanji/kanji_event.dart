part of 'kanji_bloc.dart';

sealed class KanjiEvent {
  const KanjiEvent();
}

final class GetRandomSubjectEvent extends KanjiEvent {}

final class UpdateSubjectMeaningEvent extends KanjiEvent {
  final String meaning;

  UpdateSubjectMeaningEvent({
    required this.meaning,
  });
}

final class AnswerSubjectMeaningEvent extends KanjiEvent {
  AnswerSubjectMeaningEvent();
}

final class AnswerSubjectMeaningResultEvent extends KanjiEvent {
  final bool correct;

  AnswerSubjectMeaningResultEvent({
    required this.correct,
  });
}

final class AnswerSubjectReadingResultEvent extends KanjiEvent {
  final bool correct;

  AnswerSubjectReadingResultEvent({
    required this.correct,
  });
}

final class AnswerSubjectReadingEvent extends KanjiEvent {
  final String reading;

  AnswerSubjectReadingEvent({
    required this.reading,
  });
}

final class ShowSubjectDetailsEvent extends KanjiEvent {}
