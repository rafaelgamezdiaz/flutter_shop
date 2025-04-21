import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<List<Product>> searchProductsByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
