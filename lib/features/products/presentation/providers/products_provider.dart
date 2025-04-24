import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return ProductsNotifier(productsRepository: productsRepository);
  },
);

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
    : super(ProductsState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      // product es un producto o exitente o un nuevo producto
      final product = await productsRepository.createUpdateProduct(productLike);

      // Si product ya existe en los productos del state (state.products), o sea en los productos de la lista
      // entonces isProductInList es true, sino es false
      final isProductInList = state.products.any(
        (element) => element.id == product.id,
      );

      if (!isProductInList) {
        state = state.copyWith(products: [product, ...state.products]);
        return true;
      }

      // Si el producto ya existe en la lista, entonces lo reemplazamos por el nuevo producto
      state = state.copyWith(
        products:
            state.products.map((element) {
              if (element.id == product.id) {
                return product;
              }
              return element;
            }).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLastPage || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
}
