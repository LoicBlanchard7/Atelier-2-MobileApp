import 'package:flutter/material.dart';
import 'package:reunionou/main.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/Widget/event_preview.dart';
import 'package:reunionou/screens/creation.dart';
import 'package:reunionou/screens/profile.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MySignInPage());
  }
}

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key});

  @override
  State<MySignInPage> createState() => _SigInpAppState();
}

class _SigInpAppState extends State<MySignInPage> {
  List<Widget> eventWidgetList = [];

  Future<List<Event>> _fetchEvents() async {
    return eventProvider.getEvents();
  }

  List<Widget> showEvents(List<Event> eventsList) {
    List<Widget> toShowList = [];
    for (var event in eventsList) {
      toShowList.add(EventPreview(event));
    }
    return toShowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reunionou'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newEventResult = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventCreation()),
          );
          newEventResult.then((value) => setState(() {
                if (value != null) {
                  eventProvider.addEvents(value);
                }
              }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Event>>(
        future: _fetchEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasData) {
            List<Event> list = snapshot.data as List<Event>;
            eventWidgetList = showEvents(list);
            return SingleChildScrollView(
              child: Column(
                children: eventWidgetList,
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
