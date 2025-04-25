import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../domain/entities/product.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Producto'),
          actions: [
            IconButton(
              onPressed: () async {
                final photoPath =
                    await CamaraGalleryServiceImplementation()
                        .pickImageFromGallery();

                if (photoPath == null) return;

                photoPath;

                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .updateProductImages(photoPath);
              },
              icon: const Icon(Icons.photo_library_outlined),
            ),
            IconButton(
              onPressed: () async {
                final photoPath =
                    await CamaraGalleryServiceImplementation().takePhoto();

                if (photoPath == null) return;

                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .updateProductImages(photoPath);
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        body:
            productState.isLoading
                ? const FullScreenLoader()
                : _ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (productState.product == null) return;
            final result =
                await ref
                    .read(productFormProvider(productState.product!).notifier)
                    .onSubmit();

            // Verifica si el widget está montado antes de usar el BuildContext
            if (!context.mounted) return;

            if (result) {
              showSnackBar(context, 'Producto guardado correctamente');
            } else {
              showSnackBar(context, 'Error al guardar el producto');
            }
          },
          child: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Conect to the productFormProvider
    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(
            images: productForm.images,
          ), // Anter tenia product.images, pero lo cambie para obtener la imagenes del provider
        ),

        const SizedBox(height: 10),
        Center(
          child: Text(
            productForm.title.value,
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),

          // Nombre
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTittleChange,
            errorMessage: productForm.title.errorMessage,
          ),

          // Slug
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onSlugChange,
            errorMessage: productForm.slug.errorMessage,
          ),

          // Precio
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged:
                (value) => ref
                    .read(productFormProvider(product).notifier)
                    .onPriceChange(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15),
          const Text('Extras'),

          // Sizes
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSelectedSizes:
                ref.read(productFormProvider(product).notifier).onSizeChange,
          ),
          const SizedBox(height: 5),

          // Generos
          _GenderSelector(
            selectedGender: productForm.gender,
            onSelectedGenre:
                ref.read(productFormProvider(product).notifier).onGenderChange,
          ),

          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged:
                (value) => ref
                    .read(productFormProvider(product).notifier)
                    .onStockChange(int.tryParse(value) ?? -1),
            errorMessage: productForm.inStock.errorMessage,
          ),

          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged:
                ref
                    .read(productFormProvider(product).notifier)
                    .onDescriptionChange,
          ),

          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged:
                ref.read(productFormProvider(product).notifier).onTagsChange,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final void Function(List<String> selectedSizes) onSelectedSizes;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSelectedSizes,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments:
          sizes.map((size) {
            return ButtonSegment(
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 10)),
            );
          }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSelectedSizes(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [Icons.man, Icons.woman, Icons.boy];

  final void Function(String selectedGenre) onSelectedGenre;

  const _GenderSelector({
    required this.selectedGender,
    required this.onSelectedGenre,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments:
            genders.map((size) {
              return ButtonSegment(
                icon: Icon(genderIcons[genders.indexOf(size)]),
                value: size,
                label: Text(size, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          onSelectedGenre(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover),
      );
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children:
          images.map((image) {
            late ImageProvider imageProvider;
            if (image.startsWith('http')) {
              imageProvider = NetworkImage(image);
            } else {
              imageProvider = FileImage(File(image));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: const AssetImage(
                    'assets/loaders/bottle-loader.gif',
                  ),
                  image: imageProvider,
                ),
              ),
            );
          }).toList(),
    );
  }
}
