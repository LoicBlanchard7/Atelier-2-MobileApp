import 'package:flutter/material.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/Widget/event_preview.dart';
import 'package:reunionou/screens/creation.dart';

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
  List<Widget> showEvents(List<Event> eventsList) {
    List<Widget> toShowList = [];
    for (var event in eventsList) {
      toShowList.add(EventPreview(event));
    }
    return toShowList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO : Ajouter un consumer / provider
    List<Event> evenementsTests = [
      Event(
        title: "Disparition de Lilian",
        description:
            "Mais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilian",
        time: DateTime(2023, 03, 29, 12, 00, 00),
        address: "12.34-13.78",
      ),
      Event(
        title: "Avis de recherche sur Lilian",
        description: "Lilian ne reviendra jamais",
        time: DateTime(2023, 03, 29, 12, 00, 00),
        address: "12.34-13.78",
      ),
      Event(
        title: "Retour de Lilian",
        description: "Wa lilian revient",
        time: DateTime(2023, 03, 29, 12, 00, 00),
        address: "12.34-13.78",
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Reunionou'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newEventResult = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventCreation()),
          );
          newEventResult.then((value) => setState(() {
                if (value != null) {
                  evenementsTests.add(value);
                  // TODO
                  // eventProvider.addTask(value);
                }
              }));
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: showEvents(evenementsTests),
        ),
      ),
    );
  }
}
