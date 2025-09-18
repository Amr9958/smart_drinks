enum RequestStatusEnum { pending, canceled , done }

extension RequestStatusEnumExtension on RequestStatusEnum {
  String get name {
    switch (this) {
      case RequestStatusEnum.pending:
        return 'Pending';
      case RequestStatusEnum.canceled:
        return 'Canceled';
      case RequestStatusEnum.done:
        return 'Done';
    }
  }
}