import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}
class AddToCart extends CartEvent {
  final ProductModel product;
  final int quantity;
  final Map<String, dynamic>? variants;
  const AddToCart(this.product, {this.quantity = 1, this.variants});
  @override
  List<Object?> get props => [product, quantity, variants];
}
class RemoveFromCart extends CartEvent {
  final String cartItemId;
  const RemoveFromCart(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}
class UpdateQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;
  const UpdateQuantity(this.cartItemId, this.quantity);
  @override
  List<Object?> get props => [cartItemId, quantity];
}
class ClearCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final CartModel cart;
  const CartLoaded(this.cart);
  @override
  List<Object?> get props => [cart];
}
class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartModel _cart = CartModel(userId: '', items: [], updatedAt: DateTime.now());

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    // TODO: Load from local storage or API
    emit(CartLoaded(_cart));
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final existingItem = _cart.items.indexWhere(
      (item) => item.productId == event.product.productId && 
                item.selectedVariants.toString() == event.variants.toString(),
    );

    if (existingItem >= 0) {
      final updatedItems = List<CartItem>.from(_cart.items);
      updatedItems[existingItem] = updatedItems[existingItem].copyWith(
        quantity: updatedItems[existingItem].quantity + event.quantity,
      );
      _cart = _cart.copyWith(items: updatedItems, updatedAt: DateTime.now());
    } else {
      final newItem = CartItem(
        cartItemId: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: event.product.productId,
        productName: event.product.name,
        productImage: event.product.images.isNotEmpty ? event.product.images.first : null,
        price: event.product.finalPrice,
        quantity: event.quantity,
        selectedVariants: event.variants,
        storeId: event.product.storeId,
      );
      _cart = _cart.copyWith(
        items: [..._cart.items, newItem],
        updatedAt: DateTime.now(),
      );
    }
    emit(CartLoaded(_cart));
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final updatedItems = _cart.items.where((item) => item.cartItemId != event.cartItemId).toList();
    _cart = _cart.copyWith(items: updatedItems, updatedAt: DateTime.now());
    emit(CartLoaded(_cart));
  }

  Future<void> _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) async {
    final updatedItems = _cart.items.map((item) {
      if (item.cartItemId == event.cartItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    _cart = _cart.copyWith(items: updatedItems, updatedAt: DateTime.now());
    emit(CartLoaded(_cart));
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    _cart = CartModel(userId: _cart.userId, items: [], updatedAt: DateTime.now());
    emit(CartLoaded(_cart));
  }
}
