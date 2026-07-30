import 'package:flutter/material.dart';import '../data/order_data.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_tab_button.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  int selectedTabIndex = 0;
  int selectedNavIndex = 1;

  final List<String> _tabs = ["All Orders", "Active", "Completed"];

  List<OrderModel> get _filteredOrders {
    if (selectedTabIndex == 0) return OrderData.orders;
    final status = selectedTabIndex == 1 ? OrderStatus.active : OrderStatus.completed;
    return OrderData.orders.where((order) => order.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      appBar: AppBar(
        backgroundColor: White,
        elevation: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'My Orders',
            style: TextStyle(
              color: Black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_tabs.length, (index) {
                return CustomTabButton(
                  label: _tabs[index],
                  isSelected: selectedTabIndex == index,
                  onTap: () => setState(() => selectedTabIndex = index),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          // Orders List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return OrderCard(order: _filteredOrders[index]);
              },
            ),
          ),
        ],
      ),

    );
  }
}