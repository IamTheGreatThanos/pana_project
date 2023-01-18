String formatNumberString(String text) {
  if (text != 'null') {
    String result = text.replaceAllMapped(
        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match.group(0)} ");
    return result;
  }
  return '0';
}
