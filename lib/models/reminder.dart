class Reminder {
  final int? id;
  final int? medicineID;
  final String dateAndTime;
  final String hasBeenTaken;
  Reminder( {this.id, this.medicineID, required this.dateAndTime,  required this.hasBeenTaken});
}