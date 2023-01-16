import 'package:calendar_app/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  late Map<DateTime, List<Event>> selectedEvents;

  void onSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      now = day;
    });
  }

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  List<Event> getEvent(DateTime dateTime) {
    return selectedEvents[dateTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(""), fit: BoxFit.cover)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                "Calendar",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TableCalendar(
              eventLoader: getEvent,
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
            ...getEvent(now).map((Event e) => ListTile(
                  title: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      e.title,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: FloatingActionButton.extended(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Padding(
                            padding:
                                const EdgeInsets.only(top: 15, bottom: 15.0),
                            child: Text(
                              "Add speciality to " +
                                  now.day.toString().split(" ")[0] +
                                  "/" +
                                  now.month.toString().split(" ")[0] +
                                  "/" +
                                  now.year.toString().split(" ")[0],
                            ),
                          ),
                          content: TextFormField(
                            controller: editingController,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (editingController.text.isEmpty) {
                                    Navigator.pop(context);
                                    return;
                                  } else {
                                    if (selectedEvents[now] != null) {
                                      selectedEvents[now]?.add(
                                          Event(title: editingController.text));
                                    } else {
                                      selectedEvents[now] = [
                                        Event(title: editingController.text),
                                      ];
                                    }
                                  }

                                  Navigator.pop(context);
                                  editingController.clear();
                                  setState(() {});
                                  return;
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.green),
                                )),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red),
                                ))
                          ],
                        )),
                icon: Icon(Icons.add),
                label: Text(
                  "Add event to " +
                      now.day.toString().split(" ")[0] +
                      "/" +
                      now.month.toString().split(" ")[0] +
                      "/" +
                      now.year.toString().split(" ")[0],
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
