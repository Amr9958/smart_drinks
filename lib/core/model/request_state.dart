import 'package:cafe_management_system/core/enum/request_status.dart';

abstract class RequestState {
  String get name;

  Map<String, dynamic> toJson() => {'State': name};

  static RequestState fromJson(Map<String, dynamic> json) {
    switch (json['State']) {
      case 'Pending':
        return PendingRequest();
      case 'Done':
        return CompletedRequest();
      case 'Canceled':
        return CancelledRequest();
      case 'Refunded':
        return RefundedRequest();
      default:
        throw Exception('Unknown order state: ${json['State']}');
    }
  }
}

class PendingRequest implements RequestState {
  @override
  String get name => "Pending";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class CompletedRequest implements RequestState {
  @override
  String get name => "Done";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class CancelledRequest implements RequestState {
  @override
  String get name => "Canceled";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class RefundedRequest implements RequestState {
  @override
  String get name => "Refunded";
  @override
  Map<String, dynamic> toJson() => {'State': name};
}

final Map<RequestStatusEnum, RequestState> orderStateMap = {
  RequestStatusEnum.pending: PendingRequest(),
  RequestStatusEnum.done: CompletedRequest(),
  RequestStatusEnum.canceled: CancelledRequest(),
};
