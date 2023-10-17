import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String format(String formatString) {
    return DateFormat(formatString).format(this);
  }

  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}

extension DurationExtension on Duration {
  String asHumanReadable() {
    var totalSeconds = inSeconds;
    var out = '';

    var secondsPerMinute = 60;
    var secondsPerHour = 60 * secondsPerMinute;
    var secondsPerDay = 24 * secondsPerHour;
    if (totalSeconds >= secondsPerDay) {
      var days = (totalSeconds / secondsPerDay).floor();
      out += '$days Tag';
      if (days != 1) {
        out += 'e';
      }
      out += ', ';
      totalSeconds -= days * secondsPerDay;
    }

    if (totalSeconds >= secondsPerHour) {
      var hours = (totalSeconds / secondsPerHour).floor();
      out += '$hours Stunde';
      if (hours != 1) {
        out += 'n';
      }
      out += ', ';
      totalSeconds -= hours * secondsPerHour;
    }

    if (totalSeconds >= secondsPerMinute) {
      var minutes = (totalSeconds / secondsPerMinute).floor();
      out += '$minutes Minute';
      if (minutes != 1) {
        out += 'n';
      }
      out += ', ';
      totalSeconds -= minutes * secondsPerMinute;
    }

    if (totalSeconds >= 0) {
      out += '$totalSeconds Sekunde';
      if (totalSeconds != 1) {
        out += 'n';
      }
      out += ', ';
      totalSeconds = 0;
    }

    return out.substring(0, out.length - 2);
  }
}
