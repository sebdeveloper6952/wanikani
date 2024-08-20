import 'package:equatable/equatable.dart';
import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final log = Logger('KeysBloc');

  KanjiBloc() : super(KanjiState.initial()) {
    // on<LoginWithNfcRequested>(_onLoginWithNfcRequested);
  } 
} 
