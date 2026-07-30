import '../models/order_model.dart';

class OrderData {
  static const List<OrderModel> orders = [
    OrderModel(
      orderId: "#SG-98333",
      amount: 50.00,
      date: "21/1/2025",
      status: OrderStatus.completed,
    ),
    OrderModel(
      orderId: "#SG-98421",
      amount: 50.00,
      date: "12/1/2025",
      status: OrderStatus.active,
    ),
    OrderModel(
      orderId: "#SG-91201",
      amount: 50.00,
      date: "1/2/2025",
      status: OrderStatus.completed,
    ),
  ];
}