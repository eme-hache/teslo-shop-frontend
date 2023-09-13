import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final token = ref.watch(authProvider).user?.token ?? '';
  final productsRepository = LocalRepository(LocalDatasource(token: token));

  return productsRepository;
});
