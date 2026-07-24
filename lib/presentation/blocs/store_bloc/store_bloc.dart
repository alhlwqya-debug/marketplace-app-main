import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/store_model.dart';
import '../../../data/repositories/store_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────
abstract class StoreEvent extends Equatable {
  const StoreEvent();
  @override
  List<Object?> get props => [];
}

class LoadStores extends StoreEvent {
  final String? category;
  final String? searchQuery;
  const LoadStores({this.category, this.searchQuery});
  @override
  List<Object?> get props => [category, searchQuery];
}

class LoadStoreDetail extends StoreEvent {
  final String storeId;
  const LoadStoreDetail(this.storeId);
  @override
  List<Object?> get props => [storeId];
}

class LoadSellerStore extends StoreEvent {
  final String ownerId;
  const LoadSellerStore(this.ownerId);
  @override
  List<Object?> get props => [ownerId];
}

class CreateStore extends StoreEvent {
  final StoreModel store;
  const CreateStore(this.store);
  @override
  List<Object?> get props => [store];
}

class UpdateStore extends StoreEvent {
  final StoreModel store;
  const UpdateStore(this.store);
  @override
  List<Object?> get props => [store];
}

class DeleteStore extends StoreEvent {
  final String storeId;
  const DeleteStore(this.storeId);
  @override
  List<Object?> get props => [storeId];
}

class FollowStore extends StoreEvent {
  final String storeId;
  const FollowStore(this.storeId);
  @override
  List<Object?> get props => [storeId];
}

class UnfollowStore extends StoreEvent {
  final String storeId;
  const UnfollowStore(this.storeId);
  @override
  List<Object?> get props => [storeId];
}

class LoadNearbyStores extends StoreEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;
  const LoadNearbyStores({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10,
  });
  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}

// ─── States ──────────────────────────────────────────────────────────────────
abstract class StoreState extends Equatable {
  const StoreState();
  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoresLoaded extends StoreState {
  final List<StoreModel> stores;
  final bool hasMore;
  const StoresLoaded(this.stores, {this.hasMore = true});
  @override
  List<Object?> get props => [stores, hasMore];
}

class StoreDetailLoaded extends StoreState {
  final StoreModel store;
  const StoreDetailLoaded(this.store);
  @override
  List<Object?> get props => [store];
}

class StoreCreated extends StoreState {
  final StoreModel store;
  const StoreCreated(this.store);
  @override
  List<Object?> get props => [store];
}

class StoreUpdated extends StoreState {
  final StoreModel store;
  const StoreUpdated(this.store);
  @override
  List<Object?> get props => [store];
}

class StoreDeleted extends StoreState {}

class StoreError extends StoreState {
  final String message;
  const StoreError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ────────────────────────────────────────────────────────────────────
class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository storeRepository;

  StoreBloc({required this.storeRepository}) : super(StoreInitial()) {
    on<LoadStores>(_onLoadStores);
    on<LoadStoreDetail>(_onLoadStoreDetail);
    on<LoadSellerStore>(_onLoadSellerStore);
    on<CreateStore>(_onCreateStore);
    on<UpdateStore>(_onUpdateStore);
    on<DeleteStore>(_onDeleteStore);
    on<FollowStore>(_onFollowStore);
    on<UnfollowStore>(_onUnfollowStore);
    on<LoadNearbyStores>(_onLoadNearbyStores);
  }

  Future<void> _onLoadStores(
    LoadStores event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      final stores = await storeRepository.getStores(
        category: event.category,
        searchQuery: event.searchQuery,
      );
      emit(StoresLoaded(stores));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onLoadStoreDetail(
    LoadStoreDetail event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      final store = await storeRepository.getStoreById(event.storeId);
      emit(StoreDetailLoaded(store));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onLoadSellerStore(
    LoadSellerStore event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      final store = await storeRepository.getStoreByOwnerId(event.ownerId);
      emit(StoreDetailLoaded(store));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onCreateStore(
    CreateStore event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      final store = await storeRepository.createStore(event.store);
      emit(StoreCreated(store));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onUpdateStore(
    UpdateStore event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      await storeRepository.updateStore(event.store);
      emit(StoreUpdated(event.store));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onDeleteStore(
    DeleteStore event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      await storeRepository.deleteStore(event.storeId);
      emit(StoreDeleted());
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onFollowStore(
    FollowStore event,
    Emitter<StoreState> emit,
  ) async {
    try {
      await storeRepository.followStore(event.storeId);
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onUnfollowStore(
    UnfollowStore event,
    Emitter<StoreState> emit,
  ) async {
    try {
      await storeRepository.unfollowStore(event.storeId);
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onLoadNearbyStores(
    LoadNearbyStores event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    try {
      final stores = await storeRepository.getNearbyStores(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
      );
      emit(StoresLoaded(stores));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }
}
