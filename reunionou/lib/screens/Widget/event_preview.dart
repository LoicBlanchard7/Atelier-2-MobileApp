// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/details.dart';

class EventPreview extends StatefulWidget {
  Event event;
  EventPreview(this.event, {super.key});

  @override
  State<EventPreview> createState() => _EventPreviewState(event);
}

class _EventPreviewState extends State<EventPreview> {
  Event event;
  _EventPreviewState(this.event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsApp(event)),
        );
        result.then((value) => setState(() {
              if (value != null) {
                event = value;
              }
            }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(event.title, maxLines: 1),
          subtitle: Text(event.description, maxLines: 2),
        ),
      ),
    );
  }
}
