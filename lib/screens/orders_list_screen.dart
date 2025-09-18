import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/enum/request_status.dart';
import 'package:cafe_management_system/core/model/request_state.dart';
import 'package:cafe_management_system/core/model/cafe_order_model.dart';
import 'package:cafe_management_system/core/model/beverage.dart';
import 'package:cafe_management_system/screens/order_details_screen.dart';
import 'package:cafe_management_system/screens/add_order_screen.dart';
import 'package:cafe_management_system/screens/filter_orders_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  RequestState? selectedFilter;
  
  // Sample orders for demonstration
  List<CafeOrder> orders = [
    CafeOrder(
      customerName: "أحمد محمد",
      drink: Shai(),
      specialInstructions: "سكر إضافي",
      status: PendingRequest(),
    ),
    CafeOrder(
      customerName: "سارة أحمد",
      drink: TurkishCoffee(),
      specialInstructions: "تحميص متوسط",
      status: CompletedRequest(),
    ),
    CafeOrder(
      customerName: "عمر خالد",
      drink: HibiscusTea(),
      specialInstructions: null,
      status: CancelledRequest(),
    ),
    CafeOrder(
      customerName: "فاطمة علي",
      drink: TeeOnFifty(),
      specialInstructions: "بدون سكر",
      status: PendingRequest(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الطلبات'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _navigateToFilterOrders(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick filter chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('قيد الانتظار', PendingRequest()),
                  const SizedBox(width: 8),
                  _buildFilterChip('مكتمل', CompletedRequest()),
                  const SizedBox(width: 8),
                  _buildFilterChip('ملغي', CancelledRequest()),
                  const SizedBox(width: 8),
                  _buildFilterChip('مسترد', RefundedRequest()),
                ],
              ),
            ),
          ),
          
          // Orders count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'إجمالي الطلبات: ${filteredOrders.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Orders list
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد طلبات',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddOrder(),
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, RequestState? filter) {
    final isSelected = (selectedFilter == null && filter == null) ||
        (selectedFilter != null && filter != null && selectedFilter.runtimeType == filter.runtimeType);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedFilter = selected ? filter : null;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.brown[100],
      checkmarkColor: Colors.brown[700],
    );
  }

  Widget _buildOrderCard(CafeOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToOrderDetails(order),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer name and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Drink info
              Row(
                children: [
                  const Icon(Icons.local_cafe, size: 16, color: Colors.brown),
                  const SizedBox(width: 4),
                  Text(
                    order.drink.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              
              // Special instructions
              if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty) ...[

                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.specialInstructions!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToOrderDetails(order),
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    label: const Text('عرض التفاصيل'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.brown[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(RequestState status) {
    Color color;
    IconData icon;
    String text;
    
    if (status is PendingRequest) {
      color = Colors.orange;
      icon = Icons.pending;
      text = 'قيد الانتظار';
    } else if (status is CompletedRequest) {
      color = Colors.green;
      icon = Icons.check_circle;
      text = 'مكتمل';
    } else if (status is CancelledRequest) {
      color = Colors.red;
      icon = Icons.cancel;
      text = 'ملغي';
    } else if (status is RefundedRequest) {
      color = Colors.purple;
      icon = Icons.money_off;
      text = 'مسترد';
    } else {
      color = Colors.grey;
      icon = Icons.help;
      text = 'غير معروف';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<CafeOrder> get filteredOrders {
    if (selectedFilter == null) {
      return orders;
    }
    return orders.where((order) => order.status.runtimeType == selectedFilter.runtimeType).toList();
  }

  void _navigateToOrderDetails(CafeOrder order) async {
    final updatedOrder = await Navigator.push<CafeOrder>(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: order),
      ),
    );
    
    // Update the order in the list if it was modified
    if (updatedOrder != null) {
      setState(() {
        final index = orders.indexWhere((o) => o.customerName == order.customerName);
        if (index != -1) {
          orders[index] = updatedOrder;
        }
      });
    }
  }

  void _navigateToAddOrder() async {
    final newOrder = await Navigator.push<CafeOrder>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddOrderScreen(),
      ),
    );
    
    // Add the new order to the list if created
     if (newOrder != null) {
       setState(() {
         orders.add(newOrder);
       });
       
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('تم إضافة طلب جديد للعميل: ${newOrder.customerName}'),
           backgroundColor: Colors.green,
         ),
       );
     }
  }

  void _navigateToFilterOrders() async {
    final filterResult = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterOrdersScreen(
          currentStatusFilter: selectedFilter,
          currentDrinkFilter: null, // Can be extended to track current drink filter
        ),
      ),
    );
    
    // Apply the returned filters
    if (filterResult != null) {
      setState(() {
        selectedFilter = filterResult['statusFilter'] as RequestState?;
        // Can add drink filter logic here if needed
      });
    }
  }
}