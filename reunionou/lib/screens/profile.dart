// ignore_for_file: slash_for_doc_comments
import 'package:flutter/material.dart';
import 'package:reunionou/main.dart';

/**
 * Page permettant de modifier les informations du profil de l'utilisateur
 * @author : ErwanBourlon
 */
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKeyName = GlobalKey<FormState>();
    final GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
    String? name;
    String? firstname;
    String? password;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Modification de votre profil",
            style: TextStyle(fontFamily: 'PermanentMarker'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Formulaire de modification de nom / prénom
              Form(
                key: formKeyName,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: eventProvider.myName,
                      decoration: const InputDecoration(
                        labelText: "Nouveau nom",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Merci de remplir ce champ";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: eventProvider.myFirstname,
                      decoration: const InputDecoration(
                        labelText: "Nouveau prénom",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Merci de remplir ce champ";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstname = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKeyName.currentState!.validate()) {
                            formKeyName.currentState!.save();
                            final response =
                                eventProvider.updateName(name!, firstname!);
                            response.then((value) {
                              if (value == 200) {
                                const snackBar = SnackBar(
                                    content: Text(
                                        'Nouveaux nom et prénom sauvegardés'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          }
                        },
                        child: const Text('Sauvegarder'),
                      ),
                    ),
                  ],
                ),
              ),
              // Formulaire de modification de mot de passe
              Form(
                key: formKeyPassword,
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Nouveau mot de passe",
                      ),
                      validator: (value) {
                        password = value;
                        if (value == "") {
                          return "Merci de remplir ce champ";
                        }
                        if (value!.length < 8) {
                          return "Votre mot de passe doit contenir au moins 8 caractères";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirmez le nouveau mot de passe",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Merci de remplir ce champ";
                        } else {
                          if (value != password) {
                            return "Merci de confirmer le mot de passe";
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstname = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKeyPassword.currentState!.validate()) {
                            formKeyPassword.currentState!.save();
                            final response =
                                eventProvider.updatePassword(password!);
                            response.then((value) {
                              if (value == 200) {
                                const snackBar = SnackBar(
                                    content: Text(
                                        'Nouveau mot de passe sauvegardé'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          }
                        },
                        child: const Text('Sauvegarder'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
