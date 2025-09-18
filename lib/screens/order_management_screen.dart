import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/enum/request_status.dart';
import 'package:cafe_management_system/core/model/request_state.dart';
import 'package:cafe_management_system/core/model/cafe_order_model.dart';
import 'package:cafe_management_system/core/model/beverage.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  RequestState? selectedFilter;
  
  // Sample orders for demonstration
  List<CafeOrder> orders = [
    CafeOrder(
      customerName: "Ahmed",
      drink: Shai(),
      specialInstructions: "Extra sugar",
      status: PendingRequest(),
    ),
    CafeOrder(
      customerName: "Sara",
      drink: TurkishCoffee(),
      specialInstructions: "Medium roast",
      status: CompletedRequest(),
    ),
    CafeOrder(
      customerName: "Omar",
      drink: HibiscusTea(),
      specialInstructions: null,
      status: CancelledRequest(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status Filter Buttons using RequestStatusEnum
          _buildStatusFilterButtons(),
          const SizedBox(height: 16),
          // Orders List
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(filteredOrders[index], orders.indexOf(filteredOrders[index]));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewOrder,
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusFilterButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Status:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Status filter dropdown
          DropdownButton<RequestState>(
            value: selectedFilter,
            hint: const Text('Filter by Status'),
            items: [
              PendingRequest(),
              CompletedRequest(),
              CancelledRequest(),
              RefundedRequest(),
            ].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    _buildStatusIcon(status),
                    const SizedBox(width: 8),
                    Text(_getStatusName(status)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(CafeOrder order, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.drink.name} - \$${order.drink.price}',
              style: const TextStyle(fontSize: 16),
            ),
            if (order.specialInstructions?.isNotEmpty == true)
              Text(
                'Instructions: ${order.specialInstructions}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 12),
            _buildActionButtons(order, index),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(RequestState status) {
    Color color;
    // Convert RequestState to RequestStatusEnum for consistent UI
    RequestStatusEnum statusEnum;
    
    if (status is PendingRequest) {
      statusEnum = RequestStatusEnum.pending;
      color = Colors.orange;
    } else if (status is CompletedRequest) {
      statusEnum = RequestStatusEnum.done;
      color = Colors.green;
    } else if (status is CancelledRequest) {
      statusEnum = RequestStatusEnum.canceled;
      color = Colors.red;
    } else {
      statusEnum = RequestStatusEnum.canceled; // Default fallback
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        _getStatusName(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(CafeOrder order, int index) {
    List<Widget> buttons = [];
    
    // Get available transitions based on current status
    final availableTransitions = _getAvailableTransitions(order.status);
    
    for (final transition in availableTransitions) {
      String buttonText = 'Mark as ${_getStatusName(transition)}';
      Color buttonColor;
      
      if (transition is CompletedRequest) {
        buttonColor = Colors.green;
      } else if (transition is CancelledRequest) {
        buttonColor = Colors.red;
      } else if (transition is RefundedRequest) {
        buttonColor = Colors.purple;
      } else {
        buttonColor = Colors.grey;
      }
      
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton(
            onPressed: () => _updateOrderStatus(index, transition),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 8,
      children: buttons,
    );
  }

  Color _getStatusColor(RequestStatusEnum status) {
    switch (status) {
      case RequestStatusEnum.pending:
        return Colors.orange;
      case RequestStatusEnum.done:
        return Colors.green;
      case RequestStatusEnum.canceled:
        return Colors.red;
    }
  }

  List<CafeOrder> get filteredOrders {
    if (selectedFilter == null) {
      return orders;
    }
    return orders.where((order) => order.status.runtimeType == selectedFilter.runtimeType).toList();
  }

  Widget _buildStatusIcon(RequestState status) {
    if (status is PendingRequest) {
      return const Icon(Icons.pending, color: Colors.orange);
    } else if (status is CompletedRequest) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status is CancelledRequest) {
      return const Icon(Icons.cancel, color: Colors.red);
    } else if (status is RefundedRequest) {
      return const Icon(Icons.money_off, color: Colors.purple);
    }
    return const Icon(Icons.help, color: Colors.grey);
  }

  String _getStatusName(RequestState status) {
    if (status is PendingRequest) {
      return 'Pending';
    } else if (status is CompletedRequest) {
      return 'Completed';
    } else if (status is CancelledRequest) {
      return 'Cancelled';
    } else if (status is RefundedRequest) {
      return 'Refunded';
    }
    return 'Unknown';
  }

  void _updateOrderStatus(int index, RequestState newStatus) {
    setState(() {
      final currentOrder = orders[index];
      
      // Validate the transition manually
      if (_canTransitionTo(currentOrder.status, newStatus)) {
        orders[index] = currentOrder.copyWith(status: newStatus);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order marked as ${_getStatusName(newStatus)}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error message for invalid transition
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid status transition'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _addNewOrder() {
    // Create a new order with pending status
    final newOrder = CafeOrder(
      customerName: "Customer ${orders.length + 1}",
      drink: Shai(), // Default beverage
      specialInstructions: null,
      status: PendingRequest(),
    );
    
    setState(() {
      orders.add(newOrder);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New order added as ${_getStatusName(PendingRequest())}'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  // Helper method to get available transitions for a given status
  List<RequestState> _getAvailableTransitions(RequestState currentStatus) {
    if (currentStatus is PendingRequest) {
      return [CompletedRequest(), CancelledRequest()];
    } else if (currentStatus is CompletedRequest) {
      return [RefundedRequest()];
    } else if (currentStatus is CancelledRequest) {
      return [RefundedRequest()];
    }
    return [];
  }
  
  // Helper method to validate if a transition is allowed
  bool _canTransitionTo(RequestState from, RequestState to) {
    final availableTransitions = _getAvailableTransitions(from);
    return availableTransitions.any((transition) => transition.runtimeType == to.runtimeType);
  }
}

// Example of a utility class that uses RequestStatusEnum
class OrderStatusHelper {
  /// Convert RequestState to RequestStatusEnum for UI consistency
  static RequestStatusEnum? getStatusEnum(RequestState state) {
    if (state is PendingRequest) {
      return RequestStatusEnum.pending;
    } else if (state is CompletedRequest) {
      return RequestStatusEnum.done;
    } else if (state is CancelledRequest) {
      return RequestStatusEnum.canceled;
    }
    return null;
  }
  
  /// Get all status names using the extension
  static List<String> getAllStatusNames() {
    return RequestStatusEnum.values.map((status) => status.name).toList();
  }
  
  /// Get status color based on enum
  static Color getStatusColor(RequestStatusEnum status) {
    switch (status) {
      case RequestStatusEnum.pending:
        return Colors.orange;
      case RequestStatusEnum.done:
        return Colors.green;
      case RequestStatusEnum.canceled:
        return Colors.red;
    }
  }
}