import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {}
class CreateOrder extends OrderEvent {
  final OrderModel order;
  const CreateOrder(this.order);
  @override
  List<Object?> get props => [order];
}
class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus status;
  const UpdateOrderStatus(this.orderId, this.status);
  @override
  List<Object?> get props => [orderId, status];
}
class TrackOrder extends OrderEvent {
  final String orderId;
  const TrackOrder(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

// States
abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}
class OrderCreated extends OrderState {
  final OrderModel order;
  const OrderCreated(this.order);
  @override
  List<Object?> get props => [order];
}
class OrderTrackingLoaded extends OrderState {
  final String orderId;
  final String status;
  final String? trackingNumber;
  const OrderTrackingLoaded(this.orderId, this.status, this.trackingNumber);
  @override
  List<Object?> get props => [orderId, status, trackingNumber];
}
class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<TrackOrder>(_onTrackOrder);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await orderRepository.createOrder(event.order);
      emit(OrderCreated(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatus event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await orderRepository.updateOrderStatus(event.orderId, event.status);
      final orders = await orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final tracking = await orderRepository.trackOrder(event.orderId);
      emit(OrderTrackingLoaded(
        event.orderId,
        tracking['status'],
        tracking['trackingNumber'],
      ));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
