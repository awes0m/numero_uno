//write me a enum that return the month name from the month number
enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december
}

extension MonthExtension on Month {
  String get name {
    switch (this) {
      case Month.january:
        return 'January';
      case Month.february:
        return 'February';
      case Month.march:
        return 'March';
      case Month.april:
        return 'April';
      case Month.may:
        return 'May';
      case Month.june:
        return 'June';
      case Month.july:
        return 'July';
      case Month.august:
        return 'August';
      case Month.september:
        return 'September';
      case Month.october:
        return 'October';
      case Month.november:
        return 'November';
      case Month.december:
        return 'December';
    }
  }

  static Month fromInt(int month) {
    switch (month) {
      case 1:
        return Month.january;
      case 2:
        return Month.february;
      case 3:
        return Month.march;
      case 4:
        return Month.april;
      case 5:
        return Month.may;
      case 6:
        return Month.june;
      case 7:
        return Month.july;
      case 8:
        return Month.august;
      case 9:
        return Month.september;
      case 10:
        return Month.october;
      case 11:
        return Month.november;
      case 12:
        return Month.december;
      default:
        throw ArgumentError('Invalid month number');
    }
  }
}


