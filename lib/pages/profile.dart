import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String nom;
  final String prenom;
  final String username;

  ProfilePage({required this.nom, required this.prenom, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nom: $nom',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Prénom: $prenom',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Username: $username',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graphique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon profil',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/accueil', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
          }
        },
      ),
    );
  }
}
