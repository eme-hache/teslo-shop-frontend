import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class LocalRepository extends AuthRepository {
  final AuthDataSource dataSource;

  LocalRepository({
    AuthDataSource? dataSource
  }) : dataSource = dataSource ?? LocalDataSource();
  
  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }

}