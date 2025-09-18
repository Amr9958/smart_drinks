import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/enum/request_status.dart';
import 'package:cafe_management_system/core/model/request_state.dart';
import 'package:cafe_management_system/core/model/cafe_order_model.dart';
import 'package:cafe_management_system/core/model/beverage.dart';

class OrderDetailsScreen extends StatefulWidget {
  final CafeOrder order;
  
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late CafeOrder currentOrder;
  
  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info Card
            _buildInfoCard(
              title: 'معلومات العميل',
              icon: Icons.person,
              children: [
                _buildInfoRow('اسم العميل', currentOrder.customerName),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Order Info Card
            _buildInfoCard(
              title: 'تفاصيل الطلب',
              icon: Icons.local_cafe,
              children: [
                _buildInfoRow('نوع المشروب', currentOrder.drink.name),
                if (currentOrder.specialInstructions != null && currentOrder.specialInstructions!.isNotEmpty)
                  _buildInfoRow('ملاحظات خاصة', currentOrder.specialInstructions!),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Status Card
            _buildInfoCard(
              title: 'حالة الطلب',
              icon: Icons.info,
              children: [
                Row(
                  children: [
                    _buildStatusChip(currentOrder.status),
                    const Spacer(),
                    _buildStatusIcon(currentOrder.status),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(),
            
            const SizedBox(height: 16),
            
            // Status History (if available)
            _buildStatusHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.brown[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(RequestState status) {
    Color color;
    String text;
    
    if (status is PendingRequest) {
      color = Colors.orange;
      text = 'قيد الانتظار';
    } else if (status is CompletedRequest) {
      color = Colors.green;
      text = 'مكتمل';
    } else if (status is CancelledRequest) {
      color = Colors.red;
      text = 'ملغي';
    } else if (status is RefundedRequest) {
      color = Colors.purple;
      text = 'مسترد';
    } else {
      color = Colors.grey;
      text = 'غير معروف';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusIcon(RequestState status) {
    IconData icon;
    Color color;
    
    if (status is PendingRequest) {
      icon = Icons.pending;
      color = Colors.orange;
    } else if (status is CompletedRequest) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (status is CancelledRequest) {
      icon = Icons.cancel;
      color = Colors.red;
    } else if (status is RefundedRequest) {
      icon = Icons.money_off;
      color = Colors.purple;
    } else {
      icon = Icons.help;
      color = Colors.grey;
    }
    
    return Icon(icon, color: color, size: 32);
  }

  Widget _buildActionButtons() {
    final availableTransitions = _getAvailableTransitions(currentOrder.status);
    
    if (availableTransitions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات المتاحة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTransitions.map((transition) {
            return _buildActionButton(transition);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(RequestState transition) {
    String text;
    Color color;
    IconData icon;
    
    if (transition is CompletedRequest) {
      text = 'تم الإنجاز';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (transition is CancelledRequest) {
      text = 'إلغاء الطلب';
      color = Colors.red;
      icon = Icons.cancel;
    } else if (transition is RefundedRequest) {
      text = 'استرداد';
      color = Colors.purple;
      icon = Icons.money_off;
    } else {
      text = 'تحديث';
      color = Colors.grey;
      icon = Icons.update;
    }
    
    return ElevatedButton.icon(
      onPressed: () => _updateOrderStatus(transition),
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildStatusHistory() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.brown[700]),
                const SizedBox(width: 8),
                const Text(
                  'تاريخ الحالة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusIcon(currentOrder.status),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusName(currentOrder.status),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'الحالة الحالية',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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

  String _getStatusName(RequestState status) {
    if (status is PendingRequest) {
      return 'قيد الانتظار';
    } else if (status is CompletedRequest) {
      return 'مكتمل';
    } else if (status is CancelledRequest) {
      return 'ملغي';
    } else if (status is RefundedRequest) {
      return 'مسترد';
    }
    return 'غير معروف';
  }

  void _updateOrderStatus(RequestState newStatus) {
    setState(() {
      currentOrder = currentOrder.copyWith(status: newStatus);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة الطلب إلى: ${_getStatusName(newStatus)}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الطلب'),
        content: const Text('هذه الميزة قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Return the updated order to the previous screen
    Navigator.pop(context, currentOrder);
    super.dispose();
  }
}