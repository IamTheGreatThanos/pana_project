class ImpressionData {
  int peopleCount = 1;

  void minusFunction() {
    if (peopleCount > 1) {
      peopleCount -= 1;
    }
  }

  void plusFunction() {
    if (peopleCount < 99) {
      peopleCount += 1;
    }
  }

  void dispose() {}
}
