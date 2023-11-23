import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/producto_modelo.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'mindful-audio-401511-default-rtdb.firebaseio.com';
  final List<ProductoModelo> products = [];
  //late ProductoModelo selectedProduct;

  Future<String?> createProduct(ProductoModelo product) async {
    final url = Uri.https(_baseUrl, 'productos.json');
    final resp = await http.post(url, body: json.encode(product));
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    //products.add(product);
    return product.id;
  }

  //Leer los datos de firebase
  Future<List<ProductoModelo>> loadProducts() async {
    final List<ProductoModelo> products = [];
    final url = Uri.https(_baseUrl, 'productos.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = ProductoModelo.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    return products;
  }

  Future<bool> deleteProduct(ProductoModelo value) async {
    final url = Uri.https(_baseUrl, 'productos/${value.id}.json');
    final resp = await http.delete(url);
    return resp.statusCode == 200;
  }

  Future<String?> updateProduct(ProductoModelo product) async {
    final url = Uri.https(_baseUrl, 'productos/${product.id}.json');
    await http.put(url, body: json.encode(product));
    return product.id;
  }
}
