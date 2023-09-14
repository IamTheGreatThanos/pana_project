String checkPlaceCount(String count) {
  if (count != '0') {
    if (count == '1') {
      return '$count место';
    } else if (count == '2' || count == '3' || count == '4') {
      return '$count места';
    }

    return '$count мест';
  } else {
    return '$count мест';
  }
}
