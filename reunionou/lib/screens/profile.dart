import 'package:flutter/material.dart';

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
    String? confirmedpassword;

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
        child: Column(
          children: [
            Form(
              key: formKeyName,
              child: Column(
                children: [
                  TextFormField(
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
                          print(
                              'SAVING ---nom:"${name}"---prénom:"${firstname}"---');
                          const snackBar = SnackBar(
                              content:
                                  Text('Nouveaux nom et prénom sauvegardés'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('Sauvegarder'),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formKeyPassword,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nouveau mot de passe",
                    ),
                    validator: (value) {
                      password = value;
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
                          print('SAVING --password:"${password}"---');
                          const snackBar = SnackBar(
                              content: Text('Nouveau mot de passe sauvegardé'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    );
  }
}