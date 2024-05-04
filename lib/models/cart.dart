import 'package:flutter/material.dart';
import 'package:fmobile/models/item.dart';

class Cart extends ChangeNotifier {
  List<Item> _items = [];
  double _totalPrice = 0.0;

  add(Item item, BuildContext context) {
    bool isItemInCart = false;
    for (var cartItem in _items) {
      if (item.name == cartItem.name) {
        isItemInCart = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name} is already in the cart')),
        );
        break;
      }
    }
    if (!isItemInCart) {
      item.quantity = 1; // Set the quantity to 1
      _items.add(item);
      _totalPrice += item.price;
    }
    notifyListeners();
  }

  void remove(Item item) {
    _totalPrice -= (item.quantity * item.price);
    item.quantity = 0;
    _items.remove(item);
    notifyListeners();
  }

  void removeOne(Item item) {
    if (item.quantity > 1) {
      item.quantity--;
      _totalPrice -= item.price;
      notifyListeners();
    } else {
      _totalPrice -= item.price;
      item.quantity = 0;
      _items.remove(item);
      notifyListeners();
    }
  }

  void addOne(Item item) {
    item.quantity++;
    _totalPrice += item.price;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _totalPrice = 0.0;
    notifyListeners();
  }

  int get count {
    int i = 0;
    for (var cartItem in _items) {
      i += cartItem.quantity;
    }
    return i;
  }

  double get totalPrice {
    return _totalPrice;
  }

  List<Item> get basketItems {
    return _items;
  }
}
