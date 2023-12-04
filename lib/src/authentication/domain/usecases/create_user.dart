import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  final AuthenticationRepository _repository;

  const CreateUser(this._repository);

  @override
  ResultVoid call(params) async => _repository.createUser(
        name: params.name,
        avatar: params.avatar,
        createdAt: params.createdAt,
      );
}

class CreateUserParams extends Equatable {
  final String name;
  final String createdAt;
  final String avatar;

  const CreateUserParams({
    required this.name,
    required this.createdAt,
    required this.avatar,
  });

  const CreateUserParams.empty()
      : this(
            createdAt: '_empty.createdAt',
            name: '_empty.name',
            avatar: '_empty.avatar');

  @override
  // TODO: implement props
  List<Object?> get props => [createdAt, name, avatar];
}
