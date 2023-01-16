import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'PlanEt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.utc(2000, 1, 1);
  DateTime endDate = DateTime.utc(2099, 12, 31);

  void onSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      now = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Text("Calendar"),
          TableCalendar(
            focusedDay: now,
            firstDay: startDate,
            lastDay: endDate,
            startingDayOfWeek: StartingDayOfWeek.monday,
            rowHeight: 50,
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, now),
            onDaySelected: onSelected,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
          ),
          Text("You select " + now.toString().split(" ")[0]),
        ],
      ),
    );
  }
}
