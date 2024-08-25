import 'package:flutter/material.dart';
import '../bd.dart';

class SuiviPage extends StatefulWidget {
  final String nom;
  final String prenom;
  final String username;

  SuiviPage({required this.nom, required this.prenom, required this.username});

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
          _poidsActuel = data.first['valeur_poids'];  // La dernière valeur est la plus récente
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
        backgroundColor: Colors.green,
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          onSelected: (String value) {
            switch (value) {
              case 'Accueil':
                Navigator.pushReplacementNamed(context, '/accueil', arguments: {
                  'nom': widget.nom,
                  'prenom': widget.prenom,
                  'username': widget.username,
                });
                break;
              case 'Suivi Corporel':
                Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                  'nom': widget.nom,
                  'prenom': widget.prenom,
                  'username': widget.username,
                });
                break;
              case 'Profil':
                Navigator.pushReplacementNamed(context, '/profile', arguments: {
                  'nom': widget.nom,
                  'prenom': widget.prenom,
                  'username': widget.username,
                });
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Accueil',
                child: Row(
                  children: [
                    Icon(Icons.home, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Accueil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Suivi Corporel',
                child: Row(
                  children: [
                    Icon(Icons.show_chart, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Suivi Corporel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Profil',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Profil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ];
          },
        ),
        title: Text('Suivi corporel', textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              widget.username[0].toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/connexion');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Se déconnecter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(widget.username)),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[900],
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Votre poids actuel est ${_poidsActuel ?? 'N/A'} kg',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 30),
            Text('Sélectionnez la période pour obtenir un historique :', style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateDebutController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Date début',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onTap: () => _selectDate(context, _dateDebutController),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _dateFinController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Date fin',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onTap: () => _selectDate(context, _dateFinController),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: _fetchData,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _historique.length,
                itemBuilder: (context, index) {
                  final item = _historique[index];
                  return ListTile(
                    title: Text(
                      'Poids: ${item['valeur_poids']} kg',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      'Date: ${item['date_prise']}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Graphique'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 1, // Suivi Corporel is selected
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/accueil', arguments: {
                'nom': widget.nom,
                'prenom': widget.prenom,
                'username': widget.username,
              });
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/graphique');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile', arguments: {
                'nom': widget.nom,
                'prenom': widget.prenom,
                'username': widget.username,
              });
              break;
          }
        },
      ),
    );
  }
}
