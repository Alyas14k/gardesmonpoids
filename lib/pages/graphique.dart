import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../bd.dart';
import 'package:intl/intl.dart';

class GraphiquePage extends StatefulWidget {
  @override
  _GraphiquePageState createState() => _GraphiquePageState();
}

class _GraphiquePageState extends State<GraphiquePage> {
  List<BarChartGroupData> _barGroups = [];
  List<String> _dates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final historique = await BD.instance.obtenirHistoriquePoids();
    setState(() {
      // Préparer les données pour l'histogramme
      _barGroups = historique
          .asMap()
          .entries
          .map((e) {
        double poids = e.value['valeur_poids'].toDouble();
        Color color;

        // Définir la couleur en fonction du poids
        if (poids >= 5 && poids <= 40) {
          color = Colors.yellow; // 5kg à 40kg : Jaune
        } else if (poids >= 41 && poids <= 70) {
          color = Colors.green; // 41kg à 70kg : Vert
        } else if (poids >= 71 && poids <= 90) {
          color = Colors.orange; // 71kg à 90kg : Orange
        } else if (poids >= 91) {
          color = Colors.red; // 91kg et plus : Rouge
        } else {
          color = Colors.blue; // Cas par défaut
        }

        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: poids,
              color: color,
              width: 15, // Largeur des barres
            ),
          ],
        );
      })
          .toList();

      // Corriger le format de la date si nécessaire
      DateFormat inputFormat = DateFormat('d-M-yyyy'); // Format de la date dans la base de données
      DateFormat outputFormat = DateFormat('yyyy-MM-dd'); // Format pour `DateTime.parse`

      _dates = historique.map<String>((e) {
        String rawDate = e['date_prise'].toString();
        DateTime parsedDate = inputFormat.parse(rawDate);
        return outputFormat.format(parsedDate);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphique de Tendance'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/accueil'); // Redirige vers la page d'accueil
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _barGroups.isEmpty
            ? Center(child: CircularProgressIndicator())
            : BarChart(
          BarChartData(
            barGroups: _barGroups,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < _dates.length) {
                      DateTime date = DateTime.parse(_dates[index]);
                      return Text(
                        DateFormat('dd-MM').format(date),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    } else {
                      return Text('');
                    }
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}
