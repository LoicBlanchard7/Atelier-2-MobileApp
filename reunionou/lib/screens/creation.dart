import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reunionou/models/event.dart';

class EventCreation extends StatefulWidget {
  const EventCreation({super.key});

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    timeInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? title;
    String? description;
    String? address;

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
              "Création d'un nouvel évenement",
              style: TextStyle(fontFamily: 'PermanentMarker'),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
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
                  // onSaved: (value) {
                  //   time.add(Duration(
                  //       hours: int.parse(value!.split(':')[0]),
                  //       minutes: int.parse(value.split(':')[1])));
                  // },
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
                decoration: const InputDecoration(
                  labelText: "Titre de l'évenement",
                ),
                validator: (value) => checkFormField(value),
                onSaved: (value) {
                  title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description de l'évenement",
                ),
                validator: (value) => checkFormField(value),
                onSaved: (value) {
                  description = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Lieu de l'évenement",
                ),
                validator: (value) => checkFormField(value),
                onSaved: (value) {
                  address = value;
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
                      Event event = Event(
                        title: title!,
                        description: description!,
                        time: time,
                        address: address!,
                      );
                      Navigator.of(context).pop(event);
                    }
                  },
                  child: const Text('créer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
