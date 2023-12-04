part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final String name;
  final String avatar;
  final String createdAt;

  const CreateUserEvent(
    this.name,
    this.avatar,
    this.createdAt,
  );

  @override
  List<Object> get props => [name, avatar, createdAt];
}

class GetUsersEvent extends AuthenticationEvent {
  const GetUsersEvent();
}
