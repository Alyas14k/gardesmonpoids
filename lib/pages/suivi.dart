import 'package:flutter/material.dart';
import '../bd.dart';

class SuiviPage extends StatefulWidget {
  @override
  _SuiviPageState createState() => _SuiviPageState();
}

class _SuiviPageState extends State<SuiviPage> {
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  List<Map<String, dynamic>> _historique = [];
  double? _poidsActuel;

  @override
  void initState() {
    super.initState();
    _fetchPoidsActuel();
  }

  @override
  void dispose() {
    _dateDebutController.dispose();
    _dateFinController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  void _fetchPoidsActuel() async {
    try {
      final data = await BD.instance.obtenirHistoriquePoids();  // Obtenir tout l'historique
      if (data.isNotEmpty) {
        setState(() {
          _poidsActuel = data.first['valeur_poids'];  // Le premier élément est le plus récent
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération du poids actuel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération du poids actuel')),
      );
    }
  }

  void _fetchData() async {
    if (_dateDebutController.text.isEmpty || _dateFinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez renseigner les deux dates.')),
      );
      return;
    }
    try {
      final data = await BD.instance.obtenirHistoriquePoidsParPeriode(
        _dateDebutController.text,
        _dateFinController.text,
      );
      setState(() {
        _historique = data;
      });
    } catch (e) {
      print('Erreur lors de la récupération de l\'historique: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération de l\'historique')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi Corporel'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Redirige vers la page d'accueil
          },
        ),
      ),
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_poidsActuel != null)
              Text(
                'Votre poids actuel est: $_poidsActuel kg',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _dateDebutController,
              decoration: InputDecoration(
                labelText: 'Date de début (jour-mois-année)',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                filled: true,
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.datetime,
              onTap: () {
                _selectDate(context, _dateDebutController);
              },
            ),
            TextField(
              controller: _dateFinController,
              decoration: InputDecoration(
                labelText: 'Date de fin (jour-mois-année)',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                filled: true,
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.datetime,
              onTap: () {
                _selectDate(context, _dateFinController);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Afficher l\'historique'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _historique.length,
                itemBuilder: (context, index) {
                  final item = _historique[index];
                  return ListTile(
                    title: Text(
                      'Poids: ${item['valeur_poids']} kg',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Date: ${item['date_prise']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Suivi Corporel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/accueil');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/suivi');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
