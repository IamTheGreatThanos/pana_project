import 'dart:async';

class ImpressionData {
  int peopleCount = 1;

  final _dataController = StreamController<int>();
  Stream<int> get dataStream => _dataController.stream;

  void minusFunction() {
    if (peopleCount > 1) {
      peopleCount -= 1;
      _dataController.sink.add(peopleCount);
    }
  }

  void plusFunction() {
    if (peopleCount < 99) {
      peopleCount += 1;
      _dataController.sink.add(peopleCount);
    }
  }

  void setPeopleCount(int newValue) {
    peopleCount = newValue;
    _dataController.sink.add(peopleCount);
  }

  void dispose() {
    _dataController.close();
  }
}
