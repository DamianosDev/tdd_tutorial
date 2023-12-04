import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.asNewInstance();

Future<void> init() async {
  sl
    // App logic
    ..registerFactory(
      () => AuthenticationCubit(
        createUser: sl(),
        getUsers: sl(),
      ),
    )
    // Use case
    ..registerLazySingleton(
      () => CreateUser(sl()),
    )
    ..registerLazySingleton(
      () => GetUsers(sl()),
    )
    // Repository
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )
    // Remote data source
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataImpl(sl()),
    )

    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
