import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? category;
  final String? searchQuery;
  const LoadProducts({this.category, this.searchQuery});
  @override
  List<Object?> get props => [category, searchQuery];
}
class LoadFeaturedProducts extends ProductEvent {}
class LoadProductDetail extends ProductEvent {
  final String productId;
  const LoadProductDetail(this.productId);
  @override
  List<Object?> get props => [productId];
}
class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object?> get props => [query];
}

// States
abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final bool hasMore;
  const ProductsLoaded(this.products, {this.hasMore = true});
  @override
  List<Object?> get props => [products, hasMore];
}
class ProductDetailLoaded extends ProductState {
  final ProductModel product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object?> get props => [product];
}
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProducts(
        category: event.category,
        searchQuery: event.searchQuery,
      );
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadFeaturedProducts(LoadFeaturedProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getFeaturedProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProductDetail(LoadProductDetail event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await productRepository.getProductById(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.searchProducts(event.query);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
