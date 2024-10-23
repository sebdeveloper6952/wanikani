part of 'user_cubit.dart';

enum UserStatus { loading, error, loaded }

class UserState extends Equatable {
  final UserStatus status;
  final User? user;

  const UserState({
    required this.status,
    required this.user,
  });

  static UserState initial() => const UserState(
        status: UserStatus.loading,
        user: null,
      );

  UserState copyWith({
    UserStatus? status,
    User? user,
  }) =>
      UserState(
        status: status ?? this.status,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [
        status,
        user,
      ];
}
