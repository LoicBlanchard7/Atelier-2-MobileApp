// ignore_for_file: use_build_context_synchronously, slash_for_doc_comments

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reunionou/screens/menu.dart';

/**
 * Page de connection
 * @author : ErwanBourlon
 */
class SignInApp extends StatelessWidget {
  const SignInApp({super.key});

  static const String _title = 'Connexion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title), centerTitle: true),
        body: const MySignInPage(),
      ),
    );
  }
}

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key});

  @override
  State<MySignInPage> createState() => _SigInpAppState();
}

class _SigInpAppState extends State<MySignInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool badPassword = false;

  /**
   * Méthode permettant d'afficher une page internet retournant sur la WebApp
   * Reunionou permettant de s'inscrire
   */
  void _launchUrl() async {
    // TODO : mettre lien inscription WebApp
    String url =
        "https://webetu.iutnc.univ-lorraine.fr/www/leblanc71u/atelier2/signUp";
    if (!await launchUrl(Uri.parse(url))) {
      if (kDebugMode) {
        print("URL can't be launched.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            // Label : Reunionou
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Reunionou',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            // Label : Connectez-vous
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Connectez-vous',
                style: TextStyle(fontSize: 20),
              ),
            ),
            // Cham texte : e-mail
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            // Cham texte : mot de passe
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe ',
                ),
              ),
            ),
            // Bouton : connection
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Connexion'),
                onPressed: () async {
                  setState(() {
                    final response = eventProvider.connect(
                        nameController.text, passwordController.text);
                    response.then((value) {
                      if (value == 200) {
                        badPassword = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuApp()),
                        );
                      } else {
                        badPassword = true;
                      }
                    });
                  });
                },
              ),
            ),
            // Label : e-mail/mot de passe incorrect
            if (badPassword)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'E-mail ou mot de passe incorrect',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            // Label et bouton : inscrivez-vous
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous n'avez pas de compte ?"),
                TextButton(
                  child: const Text(
                    'Inscrivez-vous',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    _launchUrl();
                  },
                )
              ],
            ),
          ],
        ));
  }
}
