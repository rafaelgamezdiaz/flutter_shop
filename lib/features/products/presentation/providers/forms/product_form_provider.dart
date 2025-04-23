import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../../domain/domain.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
      final createUpdateProductCallback;
      // TODO create onUpdateCallback
      return ProductFormNotifier(
        product: product,
        // TODO onSubmitCallback
      );
    });

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
    : super(
        ProductFormState(
          id: product.id,
          title: Title.dirty(value: product.title),
          slug: Slug.dirty(value: product.slug),
          price: Price.dirty(value: product.price),
          inStock: Stock.dirty(value: product.stock),
          sizes: product.sizes,
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        ),
      );

  Future<bool> onSubmit() async {
    _touchedEveryThing();

    print('Entro en el onSubmit $onSubmitCallback');
    if (!state.idFormValid) return false;
    // if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'description': state.description,
      'tags': state.tags.split(',').map((tag) => tag.trim()).toList(),
      'images':
          state.images
              .map(
                (image) => image.replaceAll(
                  '${Environment.apiUrl}/files/product/',
                  '',
                ),
              )
              .toList(),
    };

    return true;
    // TODO llamar onSubmitCallback
  }

  void _touchedEveryThing() {
    state = state.copyWith(
      idFormValid: Formz.validate([
        Title.dirty(value: state.title.value),
        Slug.dirty(value: state.slug.value),
        Price.dirty(value: state.price.value),
        Stock.dirty(value: state.inStock.value),
      ]),
    );
  }

  void onTittleChange(String value) {
    state = state.copyWith(
      title: Title.dirty(value: value),
      idFormValid: Formz.validate([
        Title.dirty(value: value),
        Slug.dirty(value: state.slug.value),
        Price.dirty(value: state.price.value),
        Stock.dirty(value: state.inStock.value),
      ]),
    );
  }

  void onSlugChange(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value: value),
      idFormValid: Formz.validate([
        Slug.dirty(value: value),
        Title.dirty(value: state.title.value),
        Price.dirty(value: state.price.value),
        Stock.dirty(value: state.inStock.value),
      ]),
    );
  }

  void onPriceChange(double value) {
    state = state.copyWith(
      price: Price.dirty(value: value),
      idFormValid: Formz.validate([
        Slug.dirty(value: state.slug.value),
        Title.dirty(value: state.title.value),
        Price.dirty(value: value),
        Stock.dirty(value: state.inStock.value),
      ]),
    );
  }

  void onStockChange(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value: value),
      idFormValid: Formz.validate([
        Slug.dirty(value: state.slug.value),
        Title.dirty(value: state.title.value),
        Price.dirty(value: state.price.value),
        Stock.dirty(value: value),
      ]),
    );
  }

  void onSizeChange(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChange(String value) {
    state = state.copyWith(gender: value);
  }

  void onDescriptionChange(String value) {
    state = state.copyWith(description: value);
  }

  void onTagsChange(String value) {
    state = state.copyWith(tags: value);
  }
}

// STATE
class ProductFormState {
  final bool idFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final Stock inStock;
  final List<String> sizes;
  final String gender;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.idFormValid = false,
    this.id,
    this.title = const Title.dirty(value: ''),
    this.slug = const Slug.dirty(value: ''),
    this.price = const Price.dirty(value: 0),
    this.inStock = const Stock.dirty(value: 0),
    this.sizes = const [],
    this.gender = 'men',
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? idFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    Stock? inStock,
    List<String>? sizes,
    String? gender,
    String? description,
    String? tags,
    List<String>? images,
  }) {
    return ProductFormState(
      idFormValid: idFormValid ?? this.idFormValid,
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      sizes: sizes ?? this.sizes,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      images: images ?? this.images,
    );
  }
}
