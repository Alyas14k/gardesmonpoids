import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../bd.dart';
import 'package:intl/intl.dart';

class GraphiquePage extends StatefulWidget {
  @override
  _GraphiquePageState createState() => _GraphiquePageState();
}

class _GraphiquePageState extends State<GraphiquePage> {
  List<FlSpot> _spots = [];
  List<String> _dates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final historique = await BD.instance.obtenirHistoriquePoids();
    setState(() {
      _spots = historique
          .asMap()
          .entries
          .map((e) => FlSpot(
        e.key.toDouble(),
        e.value['valeur_poids'],
      ))
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
        child: _spots.isEmpty
            ? Center(child: CircularProgressIndicator())
            : LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
              ),
            ],
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
