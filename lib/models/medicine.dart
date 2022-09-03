import 'dart:io';

class Medicine {
  final int? id;
  final String name;
  final String desc;
  final String countDays;
  final String countTimes;
  final File imagePath;

  Medicine({
    this.id,
    required this.name,
    required this.imagePath,
    required this.desc,
    required this.countDays,
    required this.countTimes,
  });

  Map<String, dynamic> mapTo(Medicine medicine){
    return {'id': id,
      'name': name,
      'desc': desc,
      'imagePath': imagePath,
    };
  }
}