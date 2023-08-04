String checkMessagesCount(String messagesCount) {
  if (messagesCount != '0') {
    if (messagesCount == '1') {
      return '$messagesCount новое сообщение';
    } else if (messagesCount == '2' ||
        messagesCount == '3' ||
        messagesCount == '4') {
      return '$messagesCount новых сообщения';
    }

    return '$messagesCount новых сообщений';
  } else {
    return 'Нет новых сообщений';
  }
}
