class DateConverter {
  const DateConverter._();

  static DateTime? intToLocalDate(int? millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch).toLocal();
  }

  static int? localDateToInt(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.toLocal().millisecondsSinceEpoch;
  }
}

