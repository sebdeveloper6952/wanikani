part of 'kanji_bloc.dart';

enum KanjiStatus { initial, loading }

class KanjiState extends Equatable {
  final KanjiStatus status;

  const KanjiState({
    required this.status,
  });

  static KanjiState initial() => const KanjiState(
        status: KanjiStatus.initial,
      );

  KanjiState copyWith({
    KanjiStatus? status,
  }) =>
      KanjiState(
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [
        status,
      ];
}
