String checkPeopleCount(String peopleCount) {
  if (peopleCount != '0') {
    if (peopleCount == '1') {
      return '$peopleCount человек';
    } else if (peopleCount == '2' || peopleCount == '3' || peopleCount == '4') {
      return '$peopleCount человека';
    }

    return '$peopleCount человек';
  } else {
    return '$peopleCount человек';
  }
}
