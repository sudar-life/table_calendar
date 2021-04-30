import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Table Calendar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List>? _events;
  List? _selectedEvents;
  AnimationController? _animationController;
  CalendarController? _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events?[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _calendarController!.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
        ],
      ),
    );
  }

  Widget _dowHeaderStyle({required String date, required Color color}) {
    return Center(
        child: Container(
            height: 30, child: Text(date, style: TextStyle(color: color))));
  }

  Widget _dayStyle(
      {required int day,
      required String subDay,
      Color? color,
      bool isToday = false,
      bool isSelected = false}) {
    var backgroundColor = const Color(0xfff7fbfd);
    if (isToday) backgroundColor = const Color(0xff5475fc);
    if (isSelected) backgroundColor = const Color(0xffd5ebff);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$day',
            style:
                TextStyle(color: isToday ? Colors.white : color, fontSize: 18),
          ),
          Text(
            subDay,
            style: TextStyle(
                fontSize: 10,
                color: isToday ? Colors.white : const Color(0xffa7a7a7)),
          ),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      headerVisible: false,
      calendarController: _calendarController!,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      startDay: DateTime(2020, 01, 01),
      endDay: DateTime(2021, 12, 01),
      calendarStyle: const CalendarStyle(
        selectedColor: Color(0xffd5ebff),
        todayColor: Color(0xff5475fc),
        outsideDaysVisible: true,
      ),
      builders: CalendarBuilders(
        dowWeekdayBuilder: (context, name) =>
            _dowHeaderStyle(date: name, color: Colors.black),
        dowWeekendBuilder: (context, name) => _dowHeaderStyle(
            date: name, color: name == '토' ? Colors.blue : Colors.red),
        outsideDayBuilder: (context, date, _) => _dayStyle(
            day: date.day, subDay: 's', color: Colors.black.withOpacity(0.3)),
        outsideWeekendDayBuilder: (context, date, _) => _dayStyle(
            day: date.day,
            subDay: 's',
            color: date.weekday == DateTime.sunday
                ? Colors.red[300]!.withOpacity(0.3)
                : Colors.blue[300]!.withOpacity(0.3)),
        weekendDayBuilder: (context, date, _) => _dayStyle(
            day: date.day,
            subDay: 's',
            color: date.weekday == DateTime.sunday
                ? Colors.red[300]!
                : Colors.blue[300]!),
        selectedDayBuilder: (context, date, _) =>
            _dayStyle(day: date.day, subDay: 's', isSelected: true),
        todayDayBuilder: (context, date, _) =>
            _dayStyle(day: date.day, subDay: 's', isToday: true),
        dayBuilder: (context, date, events) =>
            _dayStyle(day: date.day, subDay: 's'),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)

  Widget _buildButtons() {
    final dateTime = _events!.keys.elementAt(_events!.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController!.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            ElevatedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController!
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            ElevatedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController!.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController!.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents!
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
