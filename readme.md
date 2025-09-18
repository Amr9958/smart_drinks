# ☕ Cafe Management System

A Flutter application designed to help café owners in Cairo streamline their daily operations.
The app allows you to manage customer orders, track pending/completed orders, and generate sales reports to see top-selling drinks and total revenue.

---

## 🚀 Features

* Add new orders with:
  * Customer name
  * Drink type (Tea, Turkish Coffee, Hibiscus Tea, etc.)
  * Special instructions (e.g., "extra mint, ya rais")
* Track orders with different states: **Pending, Completed, Canceled, Refunded**
* **Smart State Transitions**: Only allow valid state changes (e.g., Pending → Completed/Canceled)
* **State Validation**: Automatic validation of state transitions with business logic
* View pending orders in dashboard
* Mark orders as completed or canceled with validation checks
* **Refund Management**: Handle refunds for completed orders only
* Generate reports:
  * Total orders served
  * Top-selling drinks
  * Total sales

---

## 🧑‍💻 OOP & SOLID Principles in This Project

This project applies **Object-Oriented Programming (OOP)** and **SOLID** principles to ensure clean, maintainable, and scalable code.

### 🔹 OOP Principles

1. **Encapsulation**
   * The `Order` class encapsulates customer data and provides a `copyWith` method to safely update fields.

2. **Inheritance**
   * Drink classes (`Shai`, `TeeOnFifty`, `TurkishCoffee`, `HibiscusTea`) inherit from the abstract `Beverage` class.

3. **Polymorphism**
   * Order states (`PendingRequest`, `CompletedRequest`, `CancelledRequest`, `RefundedRequest`) all implement the same interface `RequestState` but define their own behaviors.
   * Each state implements validation methods (`canTransitionTo`, `isCompleted`, `canRefund`) with specific business logic.

---

### 🔹 SOLID Principles

1. **Single Responsibility Principle (SRP)**
   * `Order` → manages order details.
   * `Beverage` → defines drinks.
   * `OrderReport` → generates analytics (totals, top drinks, sales).
   Each class has **one clear responsibility**.

2. **Open/Closed Principle (OCP)**
   * `BeverageFactory` can register new drinks without modifying existing code.
   * `RequestState` can be extended with new states without breaking existing logic.
   * `StateTransitionManager` allows adding new transition rules without modifying existing states.

3. **Liskov Substitution Principle (LSP)**
   * Any subclass of `Beverage` (e.g., `Shai`, `TurkishCoffee`) can be used wherever a `Beverage` is expected.
   * Any implementation of `RequestState` can be used interchangeably while maintaining expected behavior.

---

## 🏗️ Architecture Highlights

### State Management Pattern
- **State Pattern Implementation**: Each order state is a separate class with specific behaviors
- **Validation Layer**: Built-in validation for state transitions and business rules
- **Type Safety**: Enum-based state types prevent invalid state assignments
- **Transition Management**: Centralized logic for handling state changes

### Key Components
- **RequestState**: Abstract base class defining state interface
- **StateTransitionManager**: Handles validation and application of state changes
- **RequestStateType**: Enum ensuring type safety
- **Validation Methods**: `canTransitionTo()`, `isCompleted`, `canRefund`

---

## 🛠️ Tech Stack

* **Flutter** (UI framework)
* **Dart** (programming language)
* **SharedPreferences** (local storage for saving orders)


---

## 📌 Summary

By applying **OOP** and **SOLID (SRP, OCP, LSP)** principles with enhanced state management, the project remains flexible, scalable, and easy to maintain. The new state transition system ensures business logic integrity while allowing easy extension for new states and validation rules, making it a robust and professional café management system.