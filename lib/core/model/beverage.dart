abstract class Beverage {
  final String _name;
  final double _price;

  Beverage({required String name, required double price})
    : _name = name,
      _price = price;

  String get name => _name;
  double get price => _price;

  Map<String, dynamic> toJson() => {'name': name, 'price': price};

  static Beverage fromJson(Map<String, dynamic> json) =>
      BeverageFactory.fromJson(json);
}

class Shai extends Beverage {
  Shai() : super(name: 'Shai', price: 10.0);
}

class TeeOnFifty extends Beverage {
  TeeOnFifty() : super(name: 'Tee On Fifty', price: 8.0);
}

class TurkishCoffee extends Beverage {
  TurkishCoffee() : super(name: 'Turkish Coffee', price: 15.0);
}

class HibiscusTea extends Beverage {
  HibiscusTea() : super(name: 'Hibiscus Tea', price: 12.0);
}

class BeverageFactory {
  static final Map<String, Beverage Function()> _registry = {
    'Shai': () => Shai(),
    'Tee On Fifty': () => TeeOnFifty(),
    'Turkish Coffee': () => TurkishCoffee(),
    'Hibiscus Tea': () => HibiscusTea(),
  };

  static List<Beverage> getDrinks() => _registry.values.map((e) => e()).toList();

  static Beverage fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;

    final drinkCreator = _registry[name];
    if (drinkCreator != null) {
      return drinkCreator();
    }
    throw Exception('Unknown drink name: $name');
  }

  static void registerBeverage(String name, Beverage Function() creator) {
    _registry[name] = creator;
  }
}
