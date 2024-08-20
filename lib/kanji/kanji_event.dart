part of 'kanji_bloc.dart';

sealed class KanjiEvent {
  const KanjiEvent();
}

final class GetRandomSubjectEvent extends KanjiEvent {}

final class AnswerSubjectMeaning extends KanjiEvent {
  final int subjectId;
  final String meaning;

  AnswerSubjectMeaning({
    required this.subjectId,
    required this.meaning,
  });
}

final class AnswerSubjectMeaningResultEvent extends KanjiEvent {
  final bool correct;

  AnswerSubjectMeaningResultEvent({
    required this.correct,
  });
}

final class AnswerSubjectWritingResultEvent extends KanjiEvent {
  final bool correct;

  AnswerSubjectWritingResultEvent({
    required this.correct,
  });
}

final class AnswerSubjectWritingEvent extends KanjiEvent {
  final int subjectId;
  final String writing;

  AnswerSubjectWritingEvent({
    required this.subjectId,
    required this.writing,
  });
}

final class ShowSubjectDetailsEvent extends KanjiEvent {}
