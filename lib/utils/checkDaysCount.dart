String checkDaysCount(String daysCount) {
  if (daysCount != '0') {
    if (daysCount == '1') {
      return '$daysCount день';
    } else if (daysCount == '2' || daysCount == '3' || daysCount == '4') {
      return '$daysCount дня';
    }

    return '$daysCount дней';
  } else {
    return '$daysCount дней';
  }
}
