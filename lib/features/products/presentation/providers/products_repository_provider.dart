import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasources_implementation.dart%20';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_implementation.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final productsRepository = ProductsRepositoryImplementation(
    productsDatasource: ProductsDatasourcesImplementation(
      accessToken: accessToken,
    ),
  );

  return productsRepository;
});
