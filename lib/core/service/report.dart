import 'package:cafe_management_system/core/model/cafe_order_model.dart';
import 'package:cafe_management_system/core/model/request_state.dart';

abstract class CafeOrderAnalytics {
  /// Returns the total number of completed orders (CompletedRequest).
  int getTotalCafeOrders(List<CafeOrder> orders);

  /// Returns a map of drink names to their order counts for completed orders, sorted by count descending.
  Map<String, int> getTopSellingDrinks(List<CafeOrder> orders);

  /// Returns the total price of completed orders (CompletedRequest).
  double getTotalPrice(List<CafeOrder> orders);
}

class CafeOrderReport implements CafeOrderAnalytics {
  @override
  int getTotalCafeOrders(List<CafeOrder> orders) {
    return orders.where((order) => order.status is CompletedRequest).length;
  }

  @override
  Map<String, int> getTopSellingDrinks(List<CafeOrder> orders) {
    Map<String, int> drinkCount = {};
    for (var order in orders.where((order) => order.status is CompletedRequest)) {
      final drinkName = order.drink.name;
      drinkCount[drinkName] = (drinkCount[drinkName] ?? 0) + 1;
    }
    return Map.fromEntries(
      drinkCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  @override
  double getTotalPrice(List<CafeOrder> orders) {
    return orders.fold(0.0, (total, order) {
      if (order.status is CompletedRequest) {
        return total + order.drink.price;
      }
      return total;
    });
  }
}
