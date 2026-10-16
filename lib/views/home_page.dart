import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/order_screen.dart';
import 'package:green_bin/views/profile_page.dart';
import 'package:green_bin/views/scrap_item_page.dart';
import 'package:green_bin/views/sell_scrap_page.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/customer_provider.dart';
import '../providers/order_provider.dart';
import 'help_and_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNavIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const OrdersScreen(),
    const HelpSupportScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentOrders();
    });
  }

  Future<void> _loadRecentOrders() async {
    final customerProvider =
    Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final customerId =
        customerProvider.customer?.uid;

    debugPrint(
      'HomePage Customer ID: $customerId',
    );

    if (customerId == null || customerId.isEmpty) {
      return;
    }

    await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).fetchOrders(customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: _pages[selectedNavIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        selectedItemColor: CardGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            selectedNavIndex = index;
          });

          // Refresh orders when Orders tab is selected
          if (index == 1) {
            final customerId =
                context.read<CustomerProvider>().customer?.uid;

            if (customerId != null &&
                customerId.isNotEmpty) {
              context
                  .read<OrderProvider>()
                  .fetchOrders(customerId);
            }
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ======================================================
// HOME CONTENT
// ======================================================

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: CardGreen,

      onRefresh: () async {
        final customerId =
            context.read<CustomerProvider>().customer?.uid;

        if (customerId != null &&
            customerId.isNotEmpty) {
          await context
              .read<OrderProvider>()
              .fetchOrders(customerId);
        }
      },

      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ==================================================
            // GREETING
            // ==================================================

            Consumer<CustomerProvider>(
              builder:
                  (context, customerProvider, child) {
                final String customerName =
                customerProvider.customer?.name
                    ?.trim()
                    .isNotEmpty ==
                    true
                    ? customerProvider.customer!.name!
                    .trim()
                    : 'User';

                return RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Hello, ',
                        style: TextStyle(
                          color: CardGreen,
                          fontSize: 28,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      TextSpan(
                        text: customerName,
                        style: const TextStyle(
                          color: Black,
                          fontSize: 28,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ==================================================
            // BANNER
            // ==================================================

            ClipRRect(
              borderRadius:
              BorderRadius.circular(10),

              child: Image.asset(
                'assets/home.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // MENU CARDS
            // ==================================================

            Row(
              children: [
                // ------------------------------
                // SELL SCRAP
                // ------------------------------

                Expanded(
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(16),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SellScrapPage(),
                        ),
                      );
                    },

                    child: _menuCard(
                      icon: Icons.sell_outlined,
                      title: 'Sell Scrap',
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ------------------------------
                // MY ORDERS
                // ------------------------------

                Expanded(
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(16),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const OrdersScreen(),
                        ),
                      );
                    },

                    child: _menuCard(
                      icon:
                      Icons.receipt_long_outlined,
                      title: 'My Orders',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // SCRAP ITEMS
            // ==================================================

            SizedBox(
              width: double.infinity,

              child: InkWell(
                borderRadius:
                BorderRadius.circular(16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const ScrapItemPage(),
                    ),
                  );
                },

                child: _menuCard(
                  icon:
                  Icons.inventory_2_outlined,
                  title: 'Scrap Items',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // RECENT ORDERS TITLE
            // ==================================================

            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Black,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // RECENT ORDERS
            // ==================================================

            Consumer<OrderProvider>(
              builder:
                  (context, orderProvider, child) {
                // ------------------------------------------
                // LOADING
                // ------------------------------------------

                if (orderProvider.isLoading) {
                  return const Center(
                    child:
                    CircularProgressIndicator(
                      color: CardGreen,
                    ),
                  );
                }

                // ------------------------------------------
                // ERROR
                // ------------------------------------------

                if (orderProvider.error != null) {
                  return Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.red
                          .withOpacity(0.05),

                      borderRadius:
                      BorderRadius.circular(12),

                      border: Border.all(
                        color: Colors.red
                            .withOpacity(0.3),
                      ),
                    ),

                    child: Text(
                      'Failed to load recent orders\n\n'
                          '${orderProvider.error}',

                      style:
                      const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                // ------------------------------------------
                // LATEST 5 ORDERS
                // ------------------------------------------

                final recentOrders =
                orderProvider.orders
                    .take(5)
                    .toList();

                // ------------------------------------------
                // NO ORDERS
                // ------------------------------------------

                if (recentOrders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(
                        vertical: 20,
                      ),

                      child: Text(
                        'No recent orders',
                        style: TextStyle(
                          color: Grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }

                // ------------------------------------------
                // ORDER LIST
                // ------------------------------------------

                return Column(
                  children:
                  recentOrders.map((order) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 16,
                      ),

                      child:
                      _buildOrderCard(order),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // MENU CARD
  // ======================================================

  Widget _menuCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: LightGrey,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: DarkGrey,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Container(
            padding:
            const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: DarkGrey,

              borderRadius:
              BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: CardGreen,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Black,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // ORDER CARD
  // ======================================================

  Widget _buildOrderCard(
      OrderModel order,
      ) {
    final String status =
    order.status == OrderStatus.completed
        ? 'Completed'
        : 'Active';

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: White,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Green,
          width: 1.2,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==================================================
          // ORDER ID + STATUS
          // ==================================================

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Order ID',

                      style: TextStyle(
                        color: Grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      order.orderId,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color: Black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: CardGreen,

                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: Text(
                  status,

                  style:
                  const TextStyle(
                    color: White,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================================================
          // PAY AMOUNT
          // ==================================================

          const Text(
            'Pay Amount',

            style: TextStyle(
              color: Grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '₹${order.amount.toStringAsFixed(2)}',

            style: const TextStyle(
              color: CardGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================
          // DATE
          // ==================================================

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: CardGreen,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  order.date,

                  style:
                  const TextStyle(
                    fontSize: 14,
                    color: Black,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}