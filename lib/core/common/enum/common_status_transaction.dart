enum CommonStatusTransaction {
  success,
  failed,
  pending,
}

extension CommonStatusTransactionExtension on CommonStatusTransaction {
  String toReadableString() {
    switch (this) {
      case CommonStatusTransaction.success:
        return 'Success';
      case CommonStatusTransaction.failed:
        return 'Failed';
      case CommonStatusTransaction.pending:
        return 'Pending';
    }
  }
}
