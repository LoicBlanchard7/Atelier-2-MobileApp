// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:intl/intl.dart';
import 'package:clipboard/clipboard.dart';
import 'package:latlong2/latlong.dart';
import 'package:reunionou/main.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/models/participant.dart';
import 'package:reunionou/screens/details_map.dart';
import 'package:reunionou/screens/modification.dart';

class DetailsApp extends StatefulWidget {
  Event event;
  DetailsApp(this.event, {super.key});

  @override
  State<DetailsApp> createState() => _DetailspAppState(event);
}

class _DetailspAppState extends State<DetailsApp> {
  Event event;
  _DetailspAppState(this.event);
  List<Participant> participantsActuels = [];

  Future<String> _fetchState() async {
    switch (event.status) {
      case 'creator':
        return 'Créateur';
      case 'declined':
        return 'Absent(e)';
      case 'accepted':
        return 'Présent(e)';
      default:
        return 'Invité(e)';
    }
  }

  Future<List<Participant>> _fetchParticipants() async {
    return eventProvider.getParticipants(event);
  }

  Future<List<Comment>> _fetchComments() async {
    return eventProvider.getComments(event);
  }

  Future<List<Participant>> _fetchAllParticipants() async {
    return eventProvider.getAllParticipants(participantsActuels);
  }

  @override
  Widget build(BuildContext context) {
    bool updated = false;
    Future<void> putComment(String titre) async {
      TextEditingController commentController = TextEditingController();
      final comment = await showDialog<bool>(
        context: context,
        builder: (context) {
          final GlobalKey<FormState> formKey = GlobalKey<FormState>();
          return Form(
            key: formKey,
            child: AlertDialog(
              title: Text(titre),
              content: TextFormField(
                controller: commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Commentaire',
                ),
                validator: (value) {
                  if ('$value'.length > 255) {
                    return 'Nombre maximum de caractères : 256';
                  } else {
                    return null;
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Poster'),
                ),
              ],
            ),
          );
        },
      );
      if (comment == true && commentController.text.isNotEmpty) {
        setState(() {
          eventProvider.addComment(
              event,
              Comment(
                  author:
                      '${eventProvider.myFirstname} ${eventProvider.myName}',
                  comment: commentController.text));
        });
      }
    }

    List<Widget> getFloatingActionButtons(String state) {
      FloatingActionButton chat = FloatingActionButton(
        onPressed: () {
          putComment('Laisser un commentaire');
        },
        heroTag: null,
        child: const Icon(Icons.chat_bubble),
      );
      FloatingActionButton map = FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapPreview(
                      LatLng(47.10237958157978, 2.5262953592295556))));
        },
        heroTag: null,
        child: const Icon(Icons.pin_drop_outlined),
      );
      if (state == "Créateur") {
        return [
          chat,
          const SizedBox(height: 10),
          map,
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              String link = "https://wawTropBienCetEvent.fr";
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
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Inviter des utilisateurs"),
                    content: FutureBuilder<List<Participant>>(
                        future: _fetchAllParticipants(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Participant>> snapshot) {
                          if (snapshot.hasData) {
                            List<Participant> listAllParticipants =
                                snapshot.data as List<Participant>;
                            List<TableRow> allParticipants = [];
                            for (var personne in listAllParticipants) {
                              allParticipants.add(
                                TableRow(
                                  children: [
                                    TextButton(
                                      child: const Text('Inviter'),
                                      onPressed: () {
                                        setState(() {
                                          eventProvider.inviteToEvent(
                                              event, personne);
                                        });
                                      },
                                    ),
                                    Text(personne.name),
                                  ],
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Table(
                                children: allParticipants,
                              ),
                            );
                          }
                          return Container();
                        }),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Quitter'),
                      ),
                    ],
                  );
                },
              );
            },
            heroTag: null,
            child: const Icon(Icons.group_add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              final result = Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventUpdate(event)),
              );
              result.then((value) => setState(() {
                    if (value != null) {
                      event = value;
                      updated = true;
                    }
                  }));
            },
            heroTag: null,
            child: const Icon(Icons.edit),
          ),
        ];
      } else {
        if (state == 'Invité(e)') {
          return [
            chat,
            const SizedBox(height: 10),
            map,
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () async {
                final createur = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Créateur de l'évenement :"),
                      content: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text('Nom : '),
                              Text(event.creator.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Prénom : '),
                              Text(event.creator.firstname),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Courriel : '),
                              Text(event.creator.email),
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
                  FlutterClipboard.copy(event.creator.email).then((value) {
                    const snackBar = SnackBar(
                        content: Text('Le courriel a bien été copié !'));
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
                                text: "  Accepter l'invitation",
                                dragableIcon: Icons.arrow_forward,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                backgroundColor: const Color(0Xff11998E),
                                onSubmit: () {
                                  setState(() {
                                    eventProvider.responseToInvitation(
                                        event, "accepted");
                                    event.status = "accepted";
                                  });
                                  Navigator.pop(context);
                                  putComment(
                                      'Vous pouvez ajouter un commentaire');
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
                          const TableRow(children: [
                            SizedBox(height: 10),
                          ]),
                          TableRow(
                            children: [
                              GradientSlideToAct(
                                width: 50,
                                text: " Refuser l'invitation",
                                dragableIcon: Icons.arrow_forward,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                backgroundColor: Colors.red,
                                onSubmit: () {
                                  setState(() {
                                    eventProvider.responseToInvitation(
                                        event, "declined");
                                    event.status = "declined";
                                  });
                                  Navigator.pop(context);
                                  putComment(
                                      'Vous pouvez ajouter un commentaire');
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
        } else {
          return [
            chat,
            const SizedBox(height: 10),
            map,
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () async {
                final createur = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Créateur de l'évenement :"),
                      content: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text('Nom : '),
                              Text(event.creator.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Prénom : '),
                              Text(event.creator.firstname),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Courriel : '),
                              Text(event.creator.email),
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
                  FlutterClipboard.copy(event.creator.email).then((value) {
                    const snackBar = SnackBar(
                        content: Text('Le courriel a bien été copié !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              },
              heroTag: null,
              child: const Icon(Icons.person),
            ),
          ];
        }
      }
    }

    List<TableRow> affichageParticipants(List<Participant> participantsList) {
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
      for (var personne in participantsList) {
        toReturn.add(TableRow(
          decoration:
              const BoxDecoration(color: Color.fromARGB(150, 255, 255, 255)),
          children: [
            Text(
              ' ${personne.name}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              ' ${personne.state}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ));
      }
      return toReturn;
    }

    List<Card> affichageCommentaires(List<Comment> commentsList) {
      List<Card> toReturn = [];
      for (var comment in commentsList) {
        toReturn.add(Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: const Color(0xffEEEEEE).withOpacity(0.5),
          child: ListTile(
            title: Text(
              comment.author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(comment.comment),
          ),
        ));
      }
      return toReturn;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reunionou'),
        centerTitle: true,
        actions: [
          FutureBuilder<String>(
              future: _fetchState(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String actualState = snapshot.data as String;
                  switch (actualState) {
                    case 'Présent(e)':
                      return const Icon(Icons.beenhere, color: Colors.green);
                    case 'Absent(e)':
                      return const Icon(Icons.block, color: Colors.red);
                    case 'Invité(e)':
                      return const Icon(Icons.live_help, color: Colors.amber);
                  }
                }
                return Container();
              }),
          FutureBuilder<String>(
              future: _fetchState(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String actualState = snapshot.data as String;
                  if (actualState != "Créateur") {
                    return Center(
                      child: Text(actualState,
                          style: const TextStyle(color: Colors.grey)),
                    );
                  }
                }
                return Container();
              }),
        ],
        leading: IconButton(
            onPressed: () {
              if (updated) {
                Navigator.of(context).pop(event);
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      floatingActionButton: FutureBuilder<String>(
          future: _fetchState(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              String actualState = snapshot.data as String;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: getFloatingActionButtons(actualState),
              );
            } else {
              return Container();
            }
          }),
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
            FutureBuilder<List<Participant>>(
                future: _fetchParticipants(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Participant>> snapshot) {
                  if (snapshot.hasData) {
                    participantsActuels = snapshot.data as List<Participant>;
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff6594C0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Table(
                          border: TableBorder.all(),
                          children: affichageParticipants(participantsActuels),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            FutureBuilder<List<Comment>>(
                future: _fetchComments(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Comment>> snapshot) {
                  if (snapshot.hasData) {
                    List<Comment> list = snapshot.data as List<Comment>;
                    return Column(
                      children: affichageCommentaires(list),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
