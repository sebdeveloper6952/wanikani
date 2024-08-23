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
    on<AnswerSubjectMeaningEvent>(_onAnswerSubjectMeaning);

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
    ));

    final subject = await repo.getRandomSubject();

    emit(
      state.copyWith(
        status: KanjiStatus.waitingForMeaning,
        subject: subject,
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

    final subject = await repo.getSubjectById(event.subjectId);
    if (subject == null) {
      emit(
        state.copyWith(
          status: KanjiStatus.error,
        ),
      );
      return;
    }

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
