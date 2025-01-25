import 'package:flutter/material.dart';
import '/models/expense_model.dart';
import 'package:intl/intl.dart';

// Definisce un widget stateless chiamato `ExpenseItem`
class ExpenseItem extends StatelessWidget {
  // Costruttore della classe, riceve un oggetto `Expense`
  const ExpenseItem(this.expense, {super.key});

  // Proprietà finale per memorizzare l'oggetto `Expense`
  final Expense expense;

  // Metodo per costruire l'interfaccia utente
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Ritorna una card che rappresenta l'elemento della spesa
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.lightBlue[100],
      // Aggiunge padding interno al contenuto della card
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, // Padding orizzontale di 20 pixel
          vertical: size.height * 0.01, // Padding verticale di 16 pixel
        ),
        // Organizza gli elementi in una colonna
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Allinea il contenuto a sinistra
          children: [
            // Mostra il titolo della spesa
            Text(
              expense.title, // Usa il titolo della spesa passato come argomento
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Applica lo stile del tema
            ),
            SizedBox(
                height: size.height *
                    0.005), // Spazio verticale tra il titolo e la riga successiva
            // Riga contenente l'importo, l'icona e la data della spesa
            Row(
              children: [
                // Mostra l'importo della spesa
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Formatta l'importo con 2 decimali
                    // \$ se si vuole usare il dollaro, € per l'euro
                    Text('€${expense.amount.toStringAsFixed(2)}'),
                    SizedBox(
                        height: size.height *
                            0.005), // Spazio orizzontale tra l'importo e l'icona
                    Text(expense.category),
                    SizedBox(
                        height: size.height *
                            0.005), // Spazio orizzontale tra l'importo e l'icona
                    Text(DateFormat('dd MMMM yyyy').format(expense
                        .date)), // Mostra la data nel formato giorno mese anno
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
