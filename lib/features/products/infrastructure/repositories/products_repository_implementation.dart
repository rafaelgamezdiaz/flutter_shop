import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImplementation extends ProductsRepository {
  final ProductsDatasource productsDatasource;

  ProductsRepositoryImplementation({required this.productsDatasource});

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return productsDatasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return productsDatasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return productsDatasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return productsDatasource.searchProductsByTerm(term);
  }
}
