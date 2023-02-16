String checkReviewsCount(String reviewsCount) {
  if (reviewsCount != '0') {
    if (reviewsCount.endsWith('1')) {
      return '$reviewsCount отзыв';
    } else if (reviewsCount.endsWith('2') ||
        reviewsCount.endsWith('3') ||
        reviewsCount.endsWith('4')) {
      return '$reviewsCount отзыва';
    }

    return '$reviewsCount отзывов';
  } else {
    return 'Отзывов пока нет';
  }
}
