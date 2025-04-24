import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
      final productRepository = ref.watch(productsRepositoryProvider);
      return ProductNotifier(
        productRepository: productRepository,
        productId: productId,
      );
    });

// NOTIFIER
class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productRepository;

  ProductNotifier({required this.productRepository, required String productId})
    : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product _newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      slug: '',
      price: 0,
      stock: 0,
      sizes: [],
      description: '',
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {
      state = state.copyWith(isLoading: true);

      if (state.id == 'new') {
        state = state.copyWith(product: _newEmptyProduct(), isLoading: false);
        return;
      }
      ;

      final product = await productRepository.getProductById(state.id);
      if (mounted) {
        state = state.copyWith(product: product, isLoading: false);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}

// STATE
class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
