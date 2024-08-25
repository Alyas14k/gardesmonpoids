import 'package:flutter/material.dart';

class ResultatPage extends StatelessWidget {
  final double imc;

  ResultatPage({required this.imc});

  @override
  Widget build(BuildContext context) {
    String interpretation;

    if (imc < 18.5) {
      interpretation = "Poids insuffisant";
    } else if (imc < 24.9) {
      interpretation = "Poids normal";
    } else if (imc < 29.9) {
      interpretation = "Surpoids";
    } else if (imc < 34.9) {
      interpretation = "Obésité modérée";
    } else if (imc < 39.9) {
      interpretation = "Obésité sévère";
    } else {
      interpretation = "Obésité morbide";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Résultat IMC',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/accueil');
          },
        ),
      ),
      body: Container(
        color: Colors.blue[900], // Changer la couleur du fond ici
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 250,
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    'Votre IMC est ${imc.toStringAsFixed(2)}\n$interpretation',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Retourner à la page CalculIMC
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur de fond du bouton
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    'Re-calculer IMC',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
