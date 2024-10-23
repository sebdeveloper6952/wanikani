import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wanikani/kanji/kanji_sqlite_repo.dart';
import 'package:wanikani/wanikani/api.dart';
import 'package:wanikani/wanikani/models.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final log = Logger('KanjiBloc');
  final _tokenKey = "WANIKANI_TOKEN";
  final Database _db;
  final SharedPreferences _storage;
  late KanjiSqliteRepo _repo;

  KanjiBloc(
    Database db,
    SharedPreferences storage,
  )   : _db = db,
        _storage = storage,
        super(KanjiState.initial()) {
    on<GetRandomSubjectEvent>(_onGetRandomSubject);
    on<UpdateSubjectMeaningEvent>(_onUpdateSubjectMeaning);
    on<AnswerSubjectMeaningEvent>(_onAnswerSubjectMeaning);
    on<AnswerSubjectReadingEvent>(_onAnswerSubjectReading);
    on<MissingApiTokenEvent>(_onMissingApiToken);
    on<SetApiTokenEvent>(_onSetApiToken);

    _init();
  }

  Future<void> _init() async {
    final token = _storage.getString(_tokenKey);
    if (token == null) {
      add(MissingApiTokenEvent());
      return;
    }

    final api = WanikaniApi(token);
    _repo = KanjiSqliteRepo(api: api, db: _db);
    await _repo.init();

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

    final subject = await _repo.getRandomSubject();

    final readings = <String>[];
    if (subject!.object.toLowerCase() != "radical") {
      final randomSubjects = await _repo.getRandomSubjectsWithType(
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

    final subject = await _repo.getSubjectById(
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
            if (state.subject!.object.toLowerCase() == "radical") {
              add(GetRandomSubjectEvent());
            }
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

    final subject = await _repo.getSubjectById(
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

  Future<void> _onMissingApiToken(
    MissingApiTokenEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(
      state.copyWith(
        status: KanjiStatus.missingApiToken,
      ),
    );
  }

  Future<void> _onSetApiToken(
    SetApiTokenEvent event,
    Emitter<KanjiState> emit,
  ) async {
    emit(
      state.copyWith(
        status: KanjiStatus.loading,
      ),
    );

    final api = WanikaniApi(event.token);
    _repo = KanjiSqliteRepo(api: api, db: _db);
    await _repo.init();
    _storage.setString(_tokenKey, event.token);

    add(GetRandomSubjectEvent());
  }
}
