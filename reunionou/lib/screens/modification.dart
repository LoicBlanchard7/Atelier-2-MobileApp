// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reunionou/main.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/screens/map.dart';

class EventUpdate extends StatefulWidget {
  Event event;
  EventUpdate(this.event, {super.key});

  @override
  State<EventUpdate> createState() => _EventUpdateState(event);
}

class _EventUpdateState extends State<EventUpdate> {
  Event event;
  _EventUpdateState(this.event);
  TextEditingController addressInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  String showTime(int time) {
    if (time.toString().length > 1) {
      return '$time';
    } else {
      return '0$time';
    }
  }

  @override
  void initState() {
    addressInput.text =
        'Latitude : "${event.address.split('-')[0]}" - Longitude : "${event.address.split('-')[1]}"';
    dateInput.text = "${event.time.year}-${event.time.month}-${event.time.day}";
    timeInput.text =
        '${showTime(event.time.hour)}:${showTime(event.time.minute)}';
    descriptionInput.text = event.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String? checkFormField(value) {
      if (value == "") {
        return "Merci de remplir ce champ";
      }
      return null;
    }

    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Modification de l'évenement",
              style: TextStyle(fontFamily: 'PermanentMarker'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    event.title,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                ),
                TextFormField(
                  controller: addressInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.pin_drop_outlined),
                    labelText: "Lieu de l'évenement",
                  ),
                  readOnly: true,
                  validator: (value) => checkFormField(value),
                  onTap: () {
                    final result = Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Map()),
                    );
                    if (!mounted) return;
                    result.then((value) => setState(() {
                          if (value != null) {
                            setState(() {
                              addressInput.text = value;
                            });
                          }
                        }));
                  },
                ),
                TextFormField(
                  controller: dateInput,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Date de l'évenement"),
                  readOnly: true,
                  validator: (value) => checkFormField(value),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateInput.text = formattedDate;
                      });
                    }
                  },
                ),
                TextFormField(
                    controller: timeInput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: "Heure de l'évenement"),
                    readOnly: true,
                    validator: (value) => checkFormField(value),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 12, minute: 0),
                      );
                      if (newTime != null) {
                        DateTime time =
                            DateTime(0, 0, 0, newTime.hour, newTime.minute);
                        timeInput.text = DateFormat('HH:mm').format(time);
                      }
                    }),
                TextFormField(
                  controller: descriptionInput,
                  decoration: const InputDecoration(
                    labelText: "Description de l'évenement",
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "Merci de remplir ce champ";
                    }
                    if ('$value'.length > 255) {
                      return "Nombre maximum de caractères : 256";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        List<String> splittedDate = dateInput.text.split('-');
                        List<String> splittedTime = timeInput.text.split(':');
                        DateTime time = DateTime(
                          int.parse(splittedDate[0]),
                          int.parse(splittedDate[1]),
                          int.parse(splittedDate[2]),
                          int.parse(splittedTime[0]),
                          int.parse(splittedTime[1]),
                        );
                        event.address =
                            "${addressInput.text.split('"')[1]}-${addressInput.text.split('"')[3]}";
                        event.time = time;
                        event.description = descriptionInput.text;
                        eventProvider.updateEvent(event);
                        Navigator.of(context).pop(event);
                      }
                    },
                    child: const Text('sauvegarder'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
