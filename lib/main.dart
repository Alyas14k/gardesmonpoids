import 'package:flutter/material.dart';
import 'auth/inscription.dart';
import 'auth/connexion.dart';
import 'auth/deconnexion.dart';
import 'pages/accueil.dart';
import 'pages/graphique.dart';
import 'pages/suivi.dart';
import 'pages/profile.dart';
import 'pages/infopoids.dart';
import 'bd.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BD.instance.database;  // Initialize the database
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GardeMonPoids',
      initialRoute: '/connexion',
      routes: {
        '/inscription': (context) => InscriptionPage(),
        '/connexion': (context) => ConnexionPage(),
        '/deconnexion': (context) => DeconnexionPage(),
        '/suivi': (context) => SuiviPage(),

        '/graphique': (context) => GraphiquePage(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/accueil') {
          final args = settings.arguments as Map<String, String>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) {
                return AccueilPage(
                  nom: args['nom']!,
                  prenom: args['prenom']!,
                  username: args['username']!,
                );
              },
            );
          }
        }else if (settings.name == '/infopoids') {
          final args = settings.arguments as Map<String, String>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) {
                return InfoPoids(
                  nom: args['nom']!,
                  prenom: args['prenom']!,
                  username: args['username']!,
                );
              },
            );
          }
        }
        else if (settings.name == '/profile') {
          final args = settings.arguments as Map<String, String>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) {
                return ProfilePage(
                  nom: args['nom']!,
                  prenom: args['prenom']!,
                  username: args['username']!,
                );
              },
            );
          }
        }
        return null; // Let MaterialApp handle the unknown routes
      },
    );
  }
}
