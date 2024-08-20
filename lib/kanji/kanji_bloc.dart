import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:wanikani/wanikani/api.dart';
import 'package:wanikani/wanikani/models.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final log = Logger('KanjiBloc');
  final WanikaniApi _api;
  final Map<int, Subject> _subjects = {};

  KanjiBloc({
    WanikaniApi? api,
    required List<Subject> subjects,
  })  : _api = api ?? WanikaniApi(),
        super(KanjiState.initial()) {
    for (var subject in subjects) {
      _subjects[subject.id] = subject;
    }

    on<GetRandomSubjectEvent>(_onGetRandomSubject);
    on<AnswerSubjectMeaningEvent>(_onAnswerSubjectMeaning);
  }

  Future<void> _onGetRandomSubject(
    GetRandomSubjectEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(state.copyWith(
      status: KanjiStatus.loading,
    ));

    final randomIndex = _subjects.keys.elementAt(
      Random().nextInt(
        _subjects.length,
      ),
    );

    final randomSubject = _subjects[randomIndex];

    emit(
      state.copyWith(
        status: KanjiStatus.waitingForMeaning,
        subject: randomSubject,
      ),
    );
  }

  Future<void> _onAnswerSubjectMeaning(
    AnswerSubjectMeaningEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(
      state.copyWith(
        status: KanjiStatus.loading,
      ),
    );

    final subject = _subjects[event.subjectId];
    if (subject == null) {
      emit(
        state.copyWith(
          status: KanjiStatus.error,
        ),
      );
      return;
    }

    // compare given answer with all meanings, return if one of them is correct
    for (var meaning in subject.data.meanings) {
      if (meaning.meaning.toLowerCase() == event.meaning.toLowerCase()) {
        emit(
          state.copyWith(
            status: KanjiStatus.answerMeaningCorrect,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 1),
          () => add(GetRandomSubjectEvent()),
        );

        return;
      }
    }

    emit(
      state.copyWith(
        status: KanjiStatus.incorrectAnswer,
      ),
    );

    await Future.delayed(
      const Duration(seconds: 1),
      () => emit(
        state.copyWith(
          status: KanjiStatus.waitingForMeaning,
        ),
      ),
    );
  }
}
