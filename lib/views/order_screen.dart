import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../providers/customer_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_tab_button.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  int selectedTabIndex = 0;

  final List<String> _tabs = [
    "All Orders",
    "Active",
    "Completed",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final customerId = customerProvider.customer?.uid;

    if (customerId == null || customerId.isEmpty) {
      return;
    }

    await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).fetchOrders(customerId);
  }

  List<OrderModel> _filteredOrders(
      List<OrderModel> orders,
      ) {
    if (selectedTabIndex == 0) {
      return orders;
    }

    if (selectedTabIndex == 1) {
      return orders
          .where(
            (order) => order.status == OrderStatus.active,
      )
          .toList();
    }

    return orders
        .where(
          (order) => order.status == OrderStatus.completed,
    )
        .toList();
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
          padding: EdgeInsets.only(left: 8),
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

      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          // Loading
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (orderProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Failed to load orders\n\n${orderProvider.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          // Filter orders according to selected tab
          final orders = _filteredOrders(
            orderProvider.orders,
          );

          return Column(
            children: [
              // =========================
              // TABS
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _tabs.length,
                        (index) {
                      return CustomTabButton(
                        label: _tabs[index],
                        isSelected:
                        selectedTabIndex == index,
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // ORDERS LIST
              // =========================
              Expanded(
                child: orders.isEmpty
                    ? const Center(
                  child: Text(
                    'No orders found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder:
                      (context, index) =>
                  const SizedBox(height: 16),
                  itemBuilder:
                      (context, index) {
                    return OrderCard(
                      order: orders[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}