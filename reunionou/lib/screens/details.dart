// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:intl/intl.dart';
import 'package:clipboard/clipboard.dart';
import 'package:reunionou/models/event.dart';

class DetailsApp extends StatefulWidget {
  Event event;
  DetailsApp(this.event, {super.key});

  @override
  State<DetailsApp> createState() => _DetailspAppState(event);
}

class _DetailspAppState extends State<DetailsApp> {
  Event event;
  _DetailspAppState(this.event);

  bool jeSuisLeCreateur = false;

  List<List<String>> participants = [
    ["Lilian Leblanc", "Invité"],
    ["Léa Jarosz", "Absent"],
    ["Loïc Blanchard", "Présent"],
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> getFloatingActionButtons() {
      FloatingActionButton chat = FloatingActionButton(
        onPressed: () async {
          String commentaire = "";
          TextEditingController commentController = TextEditingController();
          final laisserUnCommentaire = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Laisser un commentaire'),
                content: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Commentaire',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Poster'),
                  ),
                ],
              );
            },
          );
          if (laisserUnCommentaire == true) {
            // TODO : mettre à jour les commentaires avec le provider
            print('Erwan : ${commentController.text}');
          }
        },
        child: const Icon(Icons.chat_bubble),
      );
      if (jeSuisLeCreateur) {
        return [
          chat,
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              String link = "https://wawTropBienCetEvent.fr";
              // TODO : await page to share
              final share = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Invitez des personnes avec ce lien :'),
                    content: Text(link),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Copier le lien'),
                      ),
                    ],
                  );
                },
              );
              if (share == true) {
                FlutterClipboard.copy("https://wawTropBienCetEvent.fr")
                    .then((value) {
                  const snackBar =
                      SnackBar(content: Text('Lien de partage copié !'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              }
            },
            heroTag: null,
            child: const Icon(Icons.share),
          ),
        ];
      } else {
        return [
          chat,
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final createur = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Créateur de l'évenement :"),
                    content: Table(
                      children: const [
                        TableRow(
                          children: [
                            Text('Nom : '),
                            Text('Bourlon'),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text('Prénom : '),
                            Text('Erwan'),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text('Courriel : '),
                            Text('erwan.bourlon8@etu.univ-lorraine.fr'),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Copier le courriel'),
                      ),
                    ],
                  );
                },
              );
              if (createur == true) {
                FlutterClipboard.copy('erwan.bourlon8@etu.univ-lorraine.fr')
                    .then((value) {
                  const snackBar =
                      SnackBar(content: Text('Le courriel a bien été copié !'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              }
            },
            heroTag: null,
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Table(
                      children: [
                        TableRow(
                          children: [
                            GradientSlideToAct(
                              width: 50,
                              text: "Accepter l'invitation",
                              dragableIcon: Icons.arrow_forward,
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              backgroundColor: const Color(0Xff11998E),
                              onSubmit: () {
                                // TODO : faire disparaitre le bouton
                                // TODO : accepter l'invitation
                                Navigator.pop(context);
                                const snackBar = SnackBar(
                                    content: Text('Invitation acceptée'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  colors: [
                                    Color(0Xff11998E),
                                    Color(0Xff38EF7D)
                                  ]),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            GradientSlideToAct(
                              width: 50,
                              text: "Refuser l'invitation",
                              dragableIcon: Icons.arrow_forward,
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              backgroundColor: Colors.red,
                              onSubmit: () {
                                // TODO : faire disparaitre le bouton
                                // TODO : refuser l'invitation
                                Navigator.pop(context);
                                const snackBar = SnackBar(
                                    content: Text('Invitation refusée'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  colors: [Colors.purple, Colors.red]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                    ],
                  );
                },
              );
            },
            heroTag: null,
            child: const Icon(Icons.mail),
          ),
        ];
      }
    }

    List<TableRow> affichageParticipants() {
      List<TableRow> toReturn = [
        TableRow(children: [
          Container(
            color: const Color(0xff091442),
            child: const Text(
              ' Participant',
              style: TextStyle(
                  color: Color(0xff6594C0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: const Color(0xff091442),
            child: const Text(
              ' Etat',
              style: TextStyle(
                  color: Color(0xff6594C0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ])
      ];
      for (var personne in participants) {
        toReturn.add(TableRow(
          decoration:
              const BoxDecoration(color: Color.fromARGB(150, 255, 255, 255)),
          children: [
            Text(
              ' ${personne[0]}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              ' ${personne[1]}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ));
      }
      return toReturn;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reunionou'), centerTitle: true),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: getFloatingActionButtons()),
      body: SingleChildScrollView(
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
            Container(
              alignment: Alignment.center,
              // padding: const EdgeInsets.all(15),
              child: Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(event.time),
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Text(
                event.description,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff6594C0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Table(
                    border: TableBorder.all(),
                    children: affichageParticipants()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
