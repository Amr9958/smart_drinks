import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/model/request_state.dart';
import 'package:cafe_management_system/core/model/cafe_order_model.dart';
import 'package:cafe_management_system/core/model/beverage.dart';

// Custom beverage class for additional drinks
class CustomBeverage extends Beverage {
  CustomBeverage({required String name, required double price})
      : super(name: name, price: price);
}

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  
  Beverage? _selectedDrink;
  
  // Custom beverage data
  static const List<Map<String, dynamic>> _customDrinks = [
    {'name': 'قهوة عربية', 'price': 15.0},
    {'name': 'كابتشينو', 'price': 20.0},
    {'name': 'لاتيه', 'price': 22.0},
    {'name': 'إسبريسو', 'price': 12.0},
    {'name': 'أمريكانو', 'price': 18.0},
    {'name': 'موكا', 'price': 25.0},
  ];

  List<Beverage> get availableDrinks {
    final drinks = <Beverage>[
      TurkishCoffee(),
      Shai(),
      TeeOnFifty(),
      HibiscusTea(),
    ];
    
    // Add custom drinks
    for (final drink in _customDrinks) {
      drinks.add(CustomBeverage(
        name: drink['name'] as String,
        price: drink['price'] as double,
      ));
    }
    
    return drinks;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طلب جديد'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOrder,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              _buildSectionCard(
                title: 'معلومات العميل',
                icon: Icons.person,
                children: [
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم العميل *',
                      hintText: 'أدخل اسم العميل',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال اسم العميل';
                      }
                      if (value.trim().length < 2) {
                        return 'اسم العميل يجب أن يكون أكثر من حرف واحد';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Drink Selection Section
              _buildSectionCard(
                title: 'اختيار المشروب',
                icon: Icons.local_cafe,
                children: [
                  DropdownButtonFormField<Beverage>(
                    value: _selectedDrink,
                    decoration: const InputDecoration(
                      labelText: 'نوع المشروب *',
                      hintText: 'اختر المشروب',
                      prefixIcon: Icon(Icons.local_cafe),
                      border: OutlineInputBorder(),
                    ),
                    items: availableDrinks.map((drink) {
                      return DropdownMenuItem<Beverage>(
                        value: drink,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(drink.name),
                            Text(
                              '${drink.price.toStringAsFixed(1)} ر.س',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Beverage? value) {
                      setState(() {
                        _selectedDrink = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'يرجى اختيار نوع المشروب';
                      }
                      return null;
                    },
                  ),
                  
                  if (_selectedDrink != null) ...[

                    const SizedBox(height: 16),
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
                          Text(
                            'السعر: ${_selectedDrink!.price.toStringAsFixed(1)} ريال سعودي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.brown[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Special Instructions Section
              _buildSectionCard(
                title: 'ملاحظات خاصة',
                icon: Icons.note_alt,
                children: [
                  TextFormField(
                    controller: _specialInstructionsController,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظات خاصة (اختياري)',
                      hintText: 'أدخل أي ملاحظات خاصة للطلب',
                      prefixIcon: Icon(Icons.note_outlined),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    maxLength: 200,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text(
                        'إعادة تعيين',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'حفظ الطلب',
                        style: TextStyle(fontSize: 16),
                      ),
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

  Widget _buildSectionCard({
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _customerNameController.clear();
    _specialInstructionsController.clear();
    setState(() {
      _selectedDrink = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إعادة تعيين النموذج'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _saveOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create new order
      final newOrder = CafeOrder(
        customerName: _customerNameController.text.trim(),
        drink: _selectedDrink!,
        status: PendingRequest(),
        specialInstructions: _specialInstructionsController.text.trim().isEmpty 
            ? null 
            : _specialInstructionsController.text.trim(),
      );
      
      // Return the new order to the previous screen
      Navigator.pop(context, newOrder);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إنشاء طلب جديد للعميل: ${newOrder.customerName}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تصحيح الأخطاء في النموذج'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}