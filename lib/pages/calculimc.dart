import 'package:flutter/material.dart';
import 'resultat.dart';

class CalculIMCPage extends StatefulWidget {
  @override
  _CalculIMCPageState createState() => _CalculIMCPageState();
}

class _CalculIMCPageState extends State<CalculIMCPage> {
  String? gender;
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void _calculateIMC() {
    final double? height = double.tryParse(heightController.text);
    final double? weight = double.tryParse(weightController.text);
    final int? age = int.tryParse(ageController.text);

    if (gender != null && height != null && weight != null && age != null) {
      final double imc = weight / ((height / 100) * (height / 100));

      // Rediriger vers la page de résultat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultatPage(imc: imc),
        ),
      );
    } else {
      // Afficher un message d'erreur si les champs ne sont pas remplis correctement
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Veuillez remplir tous les champs'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            'Calcul de l\'IMC',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context,'/accueil');
          },
        ),
      ),
      body: Container(
        color: Colors.blue[900],
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container pour Homme
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          size: 70,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Homme',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Radio<String>(
                          value: 'homme',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Container pour Femme
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          size: 70,
                          color: Colors.pink,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Femme',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Radio<String>(
                          value: 'femme',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Champ de saisie pour la taille
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Entrez votre taille (cm)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            // Champ de saisie pour le poids
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Entrez votre poids (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            // Champ de saisie pour l'âge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Entrez votre âge (ans)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            // Bouton pour calculer l'IMC
            ElevatedButton(
              onPressed: _calculateIMC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Couleur de fond du bouton
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Calculer IMC',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
