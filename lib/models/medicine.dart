import 'dart:io';

class Medicine {
  final String id;
  final String name;
  final String desc;
  final String countDays;
  final String countTimes;
  final String startHour;
  final File imagePath;

  Medicine({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.desc,
    required this.countDays,
    required this.countTimes,
    required this.startHour,
  });
}