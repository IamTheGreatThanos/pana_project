String checkNightCount(String daysCount) {
  if (daysCount != '0') {
    if (daysCount == '1') {
      return '$daysCount ночь';
    } else if (daysCount == '2' || daysCount == '3' || daysCount == '4') {
      return '$daysCount ночи';
    }

    return '$daysCount ночей';
  } else {
    return '$daysCount ночей';
  }
}
