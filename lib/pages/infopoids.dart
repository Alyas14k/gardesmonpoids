import 'package:flutter/material.dart';
import '../bd.dart';

class InfoPoids extends StatefulWidget {
  final String nom;
  final String prenom;
  final String username;

  InfoPoids({required this.nom, required this.prenom, required this.username});

  @override
  _InfoPoidsState createState() => _InfoPoidsState();
}

class _InfoPoidsState extends State<InfoPoids> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _poidsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renseigner votre poids'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.blue[900],
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poids (kg)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _poidsController,
                decoration: InputDecoration(
                  labelText: 'Poids (kg)',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre poids';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Date de prise',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (jour-mois-année)',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la date';
                  }
                  final RegExp dateRegExp = RegExp(
                    r'^(\d{1,2})-(\d{1,2})-(\d{4})$',
                  );
                  if (!dateRegExp.hasMatch(value)) {
                    return 'Veuillez entrer la date au format jour-mois-année';
                  }
                  return null;
                },
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await BD.instance.insertPoids({
                        'valeur_poids': double.parse(_poidsController.text),
                        'date_prise': _dateController.text,
                      });
                      Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                        'nom': widget.nom,
                        'prenom': widget.prenom,
                        'username': widget.username,
                      });
                    } catch (e) {
                      print('Erreur lors de l\'enregistrement du poids: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur lors de l\'enregistrement du poids')),
                      );
                    }
                  }
                },
                child: Text('Enregistrer', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
        currentIndex: 0,
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
              Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                'nom': widget.nom,
                'prenom': widget.prenom,
                'username': widget.username,
              });
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
