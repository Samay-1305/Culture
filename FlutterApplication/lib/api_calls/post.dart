import 'dart:convert';
import 'package:culture/objects/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class POST {
  final String authKey;
  POST({this.authKey});

  Future<List<Offset>> fetchChartData(id) async {
    var response;
    response = await http.post('http://52.206.9.79/api/showcase/view/', body: {
      'auth_key': authKey,
      'item_id': id.toString()
    });

    if (response.statusCode == 200) {
      return (json.decode(response.body)['graph'] as List).map((item) => Offset(item[0] * 1.0, item[1] * 1.0)).toList();
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<Item> fetchItemData(id) async {
    var response;
    response = await http.post('http://52.206.9.79/api/showcase/view/', body: {
      'auth_key': authKey,
      'item_id': id.toString()
    });

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body)['item']);
    } else {
      throw Exception('Failed to load User');
    }
  }


  Future<List<Item>> fetchPurchased() async {
    final response = await http.post('http://52.206.9.79/api/showcase/purchased/', body: {
      'auth_key': authKey,
    });

    if (response.statusCode == 200) {
      return (json.decode(response.body)['items'] as List).map((i) => Item.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load Showcase');
    }
  }


  Future<List<Item>> fetchShowcase(query) async {
    final response = await http.post('http://52.206.9.79/api/showcase/', body: {
      'auth_key': authKey,
      'query': query
    });

    if (response.statusCode == 200) {
      return (json.decode(response.body)['items'] as List).map((i) => Item.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load Showcase');
    }
  }
}