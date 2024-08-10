import 'package:flutter/material.dart';

class DeconnexionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Déconnexion')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/connexion');
          },
          child: Text('Se déconnecter'),
        ),
      ),
    );
  }
}
