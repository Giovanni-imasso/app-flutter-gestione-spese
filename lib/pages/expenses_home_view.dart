import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart'; // Importa il pacchetto Material Design.
import 'package:fl_chart/fl_chart.dart'; // Importa il pacchetto per la creazione di grafici a barre.
import '../models/expense_model.dart'; // Importa il modello delle spese.
import 'add_expense_screen.dart'; // Importa la schermata per aggiungere una nuova spesa.
import '/widgets/expense_item.dart'; // Importa il widget per visualizzare singole spese.

class ExpensesHomeView extends StatefulWidget {
  const ExpensesHomeView({super.key}); // Costruttore con chiave opzionale.

  @override
  // Crea lo stato per il widget ExpensesHomeView.
  ExpensesHomeViewState createState() => ExpensesHomeViewState();
}

class ExpensesHomeViewState extends State<ExpensesHomeView> {
  // Lista iniziale delle spese.
  List<Expense> expenses = [
    Expense(
      title: 'Spesa supermercato',
      amount: 100.0,
      category: 'Cibo',
      date: DateTime.now(),
    ),
    Expense(
      title: 'Benzina',
      amount: 50.0,
      category: 'Trasporto',
      date: DateTime.now(),
    ),
    Expense(
      title: 'Spazzatura casa',
      amount: 20.0,
      category: 'Bollette',
      date: DateTime.now(),
    ),
  ];

  // Metodo per aggiungere una spesa alla lista.
  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense); // Aggiunge la spesa alla lista di spese.
    });
  }

  // Calcola e restituisce una mappa delle spese per categoria.
  Map<String, double> getExpensesByCategory(List<Expense> expenses) {
    Map<String, double> categoryMap = {}; // Inizializza una mappa vuota.

    for (var expense in expenses) {
      // Itera su tutte le spese.
      if (categoryMap.containsKey(expense.category)) {
        // Se la categoria esiste già nella mappa...
        categoryMap[expense.category]! +
            expense.amount; // Aggiunge l'importo alla categoria esistente.
      } else {
        categoryMap[expense.category] =
            expense.amount; // Crea una nuova categoria con l'importo iniziale.
      }
    }

    return categoryMap; // Restituisce la mappa aggiornata.
  }

  // Restituisce i dati per i grafici a barre delle spese per categoria.
  Map<String, dynamic> getExpenseBars(List<Expense> expenses) {
    var categories =
        getExpensesByCategory(expenses); // Ottiene le spese per categoria.
    var categoriesList = categories.keys.toList(); // Lista delle categorie.
    var amountsList =
        categories.values.toList(); // Lista degli importi per categoria.

    // Lista dei gruppi di barre per il grafico.
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < categoriesList.length; i++) {
      bars.add(
        BarChartGroupData(
          x: i, // Indice della barra.
          barRods: [
            BarChartRodData(
              toY: amountsList[i], // Altezza della barra basata sull'importo.
              color: Colors.primaries[
                  i % Colors.primaries.length], // Colore della barra.
              width: 30, // Larghezza della barra.
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return {
      'bars': bars, // Dati delle barre.
      'categories': categoriesList, // Categorie utilizzate nel grafico.
    };
  }

  // Calcola il valore massimo tra tutte le categorie di spese.
  double getMaxY() {
    var categories =
        getExpensesByCategory(expenses); // Ottiene le spese per categoria.
    var amountsList = categories.values.toList(); // Lista degli importi.
    if (amountsList.isEmpty) {
      // Se non ci sono importi, restituisce 0.
      return 0;
    } else {
      return amountsList
          .reduce((a, b) => a > b ? a : b); // Restituisce l'importo massimo.
    }
  }

  @override
  // Costruisce l'interfaccia utente per ExpensesHomeView.
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Size è una tipologia di dati che contiene le dimensioni dello schermo.
    // Richiede al contesto di restituire le dimensioni dello schermo corrente.
    // size.width restituisce la larghezza dello schermo.
    // size.height restituisce l'altezza dello schermo.
    // Questo è utile per calcolare le dimensioni dei widget in base alle dimensioni dello schermo.
    // Ad esempio, size.width * 0.05 restituisce il 5% della larghezza dello schermo.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker',
            style:
                TextStyle(fontWeight: FontWeight.bold)), // Titolo della AppBar.
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: expenses.isEmpty
                ? const Center(child: Text('Non ci sono spese da mostrare'))
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.01,
                    ),
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false), // Nasconde la griglia.
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[900]
                                : Colors.white,
                        alignment: BarChartAlignment.spaceAround,
                        maxY: getMaxY(),
                        barGroups: getExpenseBars(expenses)['bars'],
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  getExpenseBars(expenses)['categories']
                                      [value.toInt()],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

            //child: expenses.isEmpty ? const Center(child: Text('Non ci sono spese da mostrare')) : Chart(expenses: expenses), // Mostra un grafico se ci sono spese, altrimenti un messaggio.
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: expenses.length, // Numero di spese nella lista.
              itemBuilder: (context, index) {
                final expense =
                    expenses[index]; // Ottiene la spesa all'indice corrente.
                return Dismissible(
                  key: Key(expense
                      .title), // Chiave unica basata sul titolo della spesa.
                  onDismissed: (direction) {
                    setState(() {
                      expenses.removeAt(index); // Rimuove la spesa dalla lista.
                    });

                    // Mostra una notifica di conferma.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${expense.title} eliminata')),
                    );
                  },
                  background: Container(
                    color: Theme.of(context).colorScheme.error.withOpacity(
                        0.75), // Colore di sfondo per l'azione di scorrimento.
                    margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05, // Margini orizzontali.
                      vertical: size.height * 0.01, // Margini verticali.
                    ),
                  ),
                  child: ExpenseItem(
                      expense), // Widget che mostra i dettagli della spesa.
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviga alla schermata per aggiungere una nuova spesa.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                addExpense:
                    addExpense, // Passa la funzione per aggiungere una spesa.
              ),
            ),
          );
        },
        child: const Icon(Icons.add), // Icona del pulsante.
      ),
    );
  }
}
