import 'dart:convert';

import 'package:cafe_management_system/core/model/beverage.dart';
import 'package:cafe_management_system/core/model/request_state.dart';

class CafeOrder {
  final String customerName;
  final Beverage drink;
  final String? specialInstructions;
  final RequestState status;

  const CafeOrder({
    required this.customerName,
    required this.drink,
    required this.specialInstructions,
    required this.status,
  });

  factory CafeOrder.fromJson(Map<String, dynamic> json) => CafeOrder(
    customerName: json['customerName'],

    drink: Beverage.fromJson(json['drink']),
    specialInstructions: json['specialInstructions'] ?? "",
    status: RequestState.fromJson(json['status']),
  );

  CafeOrder copyWith({
    String? customerName,
    Beverage? drink,
    String? specialInstructions,
    RequestState? status,
  }) {
    return CafeOrder(
      customerName: customerName ?? this.customerName,
      drink: drink ?? this.drink,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'drink': drink.toJson(),
    'specialInstructions': specialInstructions,
    'status': status.toJson(),
  };

  static String toJsonStr(CafeOrder data) => jsonEncode(data.toJson());
}
