import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanikani/kanji/kanji_sqlite_repo.dart';
import 'package:wanikani/wanikani/models.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final KanjiSqliteRepo _repo;
  UserCubit(KanjiSqliteRepo repo)
      : _repo = repo,
        super(UserState.initial()) {
    _init();
  }

  Future<void> _init() async {
    emit(
      state.copyWith(
        status: UserStatus.loading,
      ),
    );

    final user = await _repo.getUser();

    emit(
      state.copyWith(
        status: UserStatus.loaded,
        user: user,
      ),
    );
  }
}
