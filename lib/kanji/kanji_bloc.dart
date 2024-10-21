import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:wanikani/kanji/kanji_sqlite_repo.dart';
import 'package:wanikani/wanikani/models.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final log = Logger('KanjiBloc');
  final KanjiSqliteRepo repo;

  KanjiBloc({
    required this.repo,
  }) : super(KanjiState.initial()) {
    on<GetRandomSubjectEvent>(_onGetRandomSubject);
    on<UpdateSubjectMeaningEvent>(_onUpdateSubjectMeaning);
    on<AnswerSubjectMeaningEvent>(_onAnswerSubjectMeaning);
    on<AnswerSubjectReadingEvent>(_onAnswerSubjectReading);

    _init();
  }

  Future<void> _init() async {
    await repo.init();
    add(GetRandomSubjectEvent());
  }

  Future<void> _onGetRandomSubject(
    GetRandomSubjectEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(state.copyWith(
      status: KanjiStatus.loading,
      meaningGuess: "",
    ));

    final subject = await repo.getRandomSubject();

    final readings = <String>[];
    if (subject!.object.toLowerCase() != "radical") {
      final randomSubjects = await repo.getRandomSubjectsWithType(
        3,
        subject.object,
      );
      final subjects = <Subject>[subject, ...randomSubjects];
      for (var subject in subjects) {
        if (subject.data.readings != null) {
          for (var reading in subject.data.readings!) {
            if (reading.acceptedAnswer ?? false) {
              readings.add(reading.reading);
              break;
            }
          }
        }
      }
    }
    readings.shuffle();

    emit(
      state.copyWith(
        status: KanjiStatus.waitingForMeaning,
        subject: subject,
        readingGuesses: readings,
      ),
    );
  }

  Future<void> _onUpdateSubjectMeaning(
    UpdateSubjectMeaningEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(
      state.copyWith(
        meaningGuess: event.meaning,
      ),
    );
  }

  Future<void> _onAnswerSubjectMeaning(
    AnswerSubjectMeaningEvent event,
    Emitter<KanjiState> emit,
  ) async {
    if (state.subject == null) {
      return;
    }

    emit(
      state.copyWith(
        status: KanjiStatus.loading,
      ),
    );

    final subject = await repo.getSubjectById(
      state.subject!.id,
    );

    if (subject == null) {
      emit(
        state.copyWith(
          status: KanjiStatus.error,
        ),
      );
      return;
    }

    for (var meaning in subject.data.meanings) {
      if (meaning.meaning.toLowerCase() == state.meaningGuess.toLowerCase()) {
        emit(
          state.copyWith(
            status: KanjiStatus.answerMeaningCorrect,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 1),
          () {
            emit(
              state.copyWith(
                status: KanjiStatus.waitingForReading,
              ),
            );
          },
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

  Future<void> _onAnswerSubjectReading(
    AnswerSubjectReadingEvent event,
    Emitter<KanjiState> emit,
  ) async {
    if (state.subject == null) {
      return;
    }

    emit(
      state.copyWith(
        status: KanjiStatus.loading,
      ),
    );

    final subject = await repo.getSubjectById(
      state.subject!.id,
    );

    if (subject == null) {
      emit(
        state.copyWith(
          status: KanjiStatus.error,
        ),
      );
      return;
    }

    for (var reading in subject.data.readings!) {
      if (event.reading == reading.reading) {
        emit(
          state.copyWith(
            status: KanjiStatus.answerMeaningCorrect,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 1),
          () {
            add(GetRandomSubjectEvent());
          },
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
          status: KanjiStatus.waitingForReading,
        ),
      ),
    );
  }
}
