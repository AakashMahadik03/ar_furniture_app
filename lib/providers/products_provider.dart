import 'dart:convert';

import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/models/product.dart';
import 'package:flutter/material.dart';

class ProductProviderModel extends ChangeNotifier {
  List<ProductItemModel> _products = [];
  List<String> _favourites = [];

  List get products {
    return [..._products];
  }

  List get favourites {
    return [..._favourites];
  }

  void addProduct(ProductItemModel product) {
    _products.add(product);
    notifyListeners();
  }

  ProductItemModel getProductById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void toggleFavourite(String id) async {
    final product = getProductById(id);
    // debugPrint(product.toString());
    final prevFavStat = product.isFavourite;
    product.isFavourite = !product.isFavourite;
    if (product.isFavourite) {
      _favourites.add(product.id);
    } else {
      _favourites.remove(product.id);
    }
    // debugPrint('in fav');

    notifyListeners();
    try {
      await FirebaseHelper.toggleFavouritesInFirestore(id, product.isFavourite);
    } catch (error) {
      product.isFavourite = prevFavStat;
      if (product.isFavourite) {
        _favourites.add(product.id);
      } else {
        _favourites.remove(product.id);
      }
      notifyListeners();
      debugPrint('Error updating fav stat');
    }
  }

  Future<void> getAndSetProducts() async {
    debugPrint('sdkdsjdjfdjndndkfndakkad');
    try {
      final productsCollection = FirebaseHelper.getProductsCollection();
      final products = await productsCollection.get();
      await getAndSetFavourites();

      print(products);
      final List<ProductItemModel> loadedProducts = [];
      for (var element in products.docs) {
        // print(element.data()['modelUrl']);
        loadedProducts.add(ProductItemModel(
          id: element.id,
          title: element.data()['title'],
          description: element.data()['description'],
          price: double.parse(element.data()['price']),
          images: Map<String, List<dynamic>>.from(element.data()['images']),
          // images: {
          //   '': ['']
          // },
          vector: element.data()['vector'],
          categories: List<String>.from(element.data()['category']),
          modelUrl: element.data()['model_url'],
          isFavourite: _favourites.contains(element.id) ? true : false,
        ));
      }
      // print(loadedProducts.toString());

      _products = loadedProducts;
      // print(products.docs);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getAndSetFavourites() async {
    final userFavouritesCollection =
        FirebaseHelper.getUserFavouritesCollection();
    final favourites = await userFavouritesCollection.get();
    final List<String> loadedFavourites = [];
    for (var element in favourites.docs) {
      if (element.data()['isFavourite']) {
        loadedFavourites.add(element.id);
      }
    }

    _favourites = loadedFavourites;
  }

  List<ProductItemModel> getProductsByCategory(String category) {
    return _products
        .where((element) => element.categories.contains(category))
        .toList();
  }
}
