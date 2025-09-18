import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/model/request_state.dart';
import 'package:cafe_management_system/core/model/beverage.dart';

class FilterOrdersScreen extends StatefulWidget {
  final RequestState? currentStatusFilter;
  final String? currentDrinkFilter;
  
  const FilterOrdersScreen({
    super.key,
    this.currentStatusFilter,
    this.currentDrinkFilter,
  });

  @override
  State<FilterOrdersScreen> createState() => _FilterOrdersScreenState();
}

class _FilterOrdersScreenState extends State<FilterOrdersScreen> {
  RequestState? selectedStatusFilter;
  String? selectedDrinkFilter;
  
  // Available drink types for filtering
  final List<String> availableDrinkTypes = [
    'Turkish Coffee',
    'Shai',
    'Tee On Fifty',
    'Hibiscus Tea',
    'قهوة عربية',
    'كابتشينو',
    'لاتيه',
    'إسبريسو',
    'أمريكانو',
    'موكا',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatusFilter = widget.currentStatusFilter;
    selectedDrinkFilter = widget.currentDrinkFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فلترة الطلبات'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'مسح الكل',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Filter Section
            _buildFilterSection(
              title: 'فلترة حسب الحالة',
              icon: Icons.filter_list,
              child: _buildStatusFilter(),
            ),
            
            const SizedBox(height: 24),
            
            // Drink Type Filter Section
            _buildFilterSection(
              title: 'فلترة حسب نوع المشروب',
              icon: Icons.local_cafe,
              child: _buildDrinkFilter(),
            ),
            
            const Spacer(),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      children: [
        _buildStatusOption(
          title: 'قيد الانتظار',
          subtitle: 'الطلبات التي لم يتم إنجازها بعد',
          icon: Icons.pending,
          color: Colors.orange,
          isSelected: selectedStatusFilter is PendingRequest,
          onTap: () => _selectStatusFilter(PendingRequest()),
        ),
        const SizedBox(height: 8),
        _buildStatusOption(
          title: 'مكتملة',
          subtitle: 'الطلبات التي تم إنجازها بنجاح',
          icon: Icons.check_circle,
          color: Colors.green,
          isSelected: selectedStatusFilter is CompletedRequest,
          onTap: () => _selectStatusFilter(CompletedRequest()),
        ),
        const SizedBox(height: 8),
        _buildStatusOption(
          title: 'ملغية',
          subtitle: 'الطلبات التي تم إلغاؤها',
          icon: Icons.cancel,
          color: Colors.red,
          isSelected: selectedStatusFilter is CancelledRequest,
          onTap: () => _selectStatusFilter(CancelledRequest()),
        ),
        const SizedBox(height: 8),
        _buildStatusOption(
          title: 'مستردة',
          subtitle: 'الطلبات التي تم استرداد قيمتها',
          icon: Icons.money_off,
          color: Colors.purple,
          isSelected: selectedStatusFilter is RefundedRequest,
          onTap: () => _selectStatusFilter(RefundedRequest()),
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinkFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر نوع المشروب:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedDrinkFilter,
          decoration: const InputDecoration(
            hintText: 'جميع المشروبات',
            prefixIcon: Icon(Icons.local_cafe),
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('جميع المشروبات'),
            ),
            ...availableDrinkTypes.map((drink) {
              return DropdownMenuItem<String>(
                value: drink,
                child: Text(drink),
              );
            }),
          ],
          onChanged: (String? value) {
            setState(() {
              selectedDrinkFilter = value;
            });
          },
        ),
        if (selectedDrinkFilter != null) ...[

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.brown[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيتم عرض الطلبات التي تحتوي على: $selectedDrinkFilter',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'تطبيق الفلاتر',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _selectStatusFilter(RequestState status) {
    setState(() {
      if (selectedStatusFilter.runtimeType == status.runtimeType) {
        // If the same status is selected, deselect it
        selectedStatusFilter = null;
      } else {
        selectedStatusFilter = status;
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      selectedStatusFilter = null;
      selectedDrinkFilter = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم مسح جميع الفلاتر'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _applyFilters() {
    // Return the selected filters to the previous screen
    Navigator.pop(context, {
      'statusFilter': selectedStatusFilter,
      'drinkFilter': selectedDrinkFilter,
    });
    
    // Show confirmation message
    String message = 'تم تطبيق الفلاتر';
    if (selectedStatusFilter != null || selectedDrinkFilter != null) {
      List<String> appliedFilters = [];
      if (selectedStatusFilter != null) {
        appliedFilters.add(_getStatusName(selectedStatusFilter!));
      }
      if (selectedDrinkFilter != null) {
        appliedFilters.add(selectedDrinkFilter!);
      }
      message = 'تم تطبيق الفلاتر: ${appliedFilters.join(', ')}';
    } else {
      message = 'تم إزالة جميع الفلاتر';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
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
}