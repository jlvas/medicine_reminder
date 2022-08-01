import 'package:flutter/material.dart';

class DaysAndTimes extends StatefulWidget {
  const DaysAndTimes({Key? key}) : super(key: key);

  @override
  State<DaysAndTimes> createState() => _DaysAndTimesState();
}

class _DaysAndTimesState extends State<DaysAndTimes> {
  final TextEditingController _countDays = TextEditingController();
  final TextEditingController _countTimes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _countDays,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'How Many Days'
          ),
        ),
        TextField(
          controller: _countTimes,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'How Many Times',
          ),
        )
      ],
    );
  }
}
