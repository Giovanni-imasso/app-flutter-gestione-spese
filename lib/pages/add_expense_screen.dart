// Importa il pacchetto Material Design.
import 'package:flutter/material.dart';

// Importa il modello di spesa.
import '../models/expense_model.dart';

// Importa il pacchetto specifico di iOS (Cupertino).
import 'package:flutter/cupertino.dart';

// Importa il pacchetto per la formattazione delle date.
import 'package:intl/intl.dart';

// Importa il modello delle categorie.
import '../models/categories.dart';

// Definisce la classe AddExpenseScreen che è uno StatefulWidget.
class AddExpenseScreen extends StatefulWidget {
  // Definisce una funzione callback per aggiungere una spesa.
  final Function addExpense;

  // Costruttore della classe che richiede la funzione di aggiunta spesa.
  const AddExpenseScreen({
    super.key,
    required this.addExpense, // Rende obbligatoria la funzione addExpense.
  });

  @override
  // Crea lo stato per AddExpenseScreen.
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

// Definisce lo stato per AddExpenseScreen.
class AddExpenseScreenState extends State<AddExpenseScreen> {
  // Questa chiave globale viene utilizzata per identificare univocamente il form e interagire con esso.
  // in riga 116 c'è il form e in riga 72 si usa questa chiave per capire se l'azione dentro il form è valida o no.
  final _formKey = GlobalKey<FormState>(); 

  // Controller per il campo del titolo.
  final _titleController = TextEditingController();

  // Controller per il campo dell'importo.
  final _amountController = TextEditingController();

  // Variabile per tenere traccia della data selezionata.
  DateTime? _selectedDate;

  // Categoria di default selezionata.
  String _selectedCategory = 'Tempo libero';

  // Controller per il campo di testo della nuova categoria.
  final _categoryController = TextEditingController();

  // Funzione per aggiungere una nuova categoria alla lista delle categorie.
  void _addCategory() {
    // Legge il testo dall'input.
    final newCategory = _categoryController.text;

    // Controlla se la categoria è valida e non già presente.
    if (newCategory.isNotEmpty && !Categories().categories.contains(newCategory)) {
      setState(() {
        // Aggiunge la nuova categoria.
        Categories().addCategory(newCategory);
      });
      // Pulisce il campo di input dopo l'aggiunta.
      _categoryController.clear();
    }
  }

  // Funzione per mostrare un DatePicker e permettere all'utente di selezionare una data.
  void _selectDate() async {
    showModalBottomSheet(
      // Passa il contesto attuale.
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          // Imposta l'altezza del picker.
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            // Usa il formato 24 ore.
            use24hFormat: false,
            // Mostra il giorno della settimana.
            showDayOfWeek: true,
            // Imposta l'anno massimo al corrente.
            maximumYear: DateTime.now().year,
            // Imposta la data iniziale a oggi.
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                // Aggiorna la data selezionata.
                _selectedDate = newDate;
              });
            },
            // Imposta la modalità a solo data.
            mode: CupertinoDatePickerMode.date,
          ),
        );
      },
    );
  }

  // Funzione per salvare la spesa inserita dall'utente.
  void _saveExpense() {
    // Controlla se il form è valido e se una data è stata selezionata.
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final expense = Expense(
        // Prende il titolo dall'input.
        title: _titleController.text,
        // Converte l'importo in double.
        amount: double.parse(_amountController.text),
        // Usa la data selezionata.
        date: _selectedDate!,
        // Usa la categoria selezionata.
        category: _selectedCategory,
      );
      // Chiama la funzione addExpense con la nuova spesa.
      widget.addExpense(expense);
      // Chiude la schermata corrente.
      Navigator.pop(context);
    }
  }

  @override
  // Metodo chiamato quando il widget viene rimosso dall'albero dei widget.
  void dispose() {
    // Libera le risorse del controller del titolo.
    _titleController.dispose();
    // Libera le risorse del controller dell'importo.
    _amountController.dispose();
    // Libera le risorse del controller della categoria.
    _categoryController.dispose();
    super.dispose(); // Chiama il metodo dispose della classe base.
  }

  @override
  // Costruisce l'interfaccia utente per AddExpenseScreen.
  Widget build(BuildContext context) {
    // Ottiene le dimensioni dello schermo.
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // Titolo della AppBar.
        title: const Text('Nuova Spesa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            // Chiude la schermata quando premuto.
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        // Imposta il padding basato sulla larghezza dello schermo.
        padding: EdgeInsets.all(size.width * 0.05),
        child: Form(
          // Assegna la chiave globale al form.
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // Collega il controller del titolo.
                controller: _titleController,
                // Imposta l'etichetta del campo.
                decoration: const InputDecoration(labelText: 'Titolo'),
                // Validazione del campo.
                validator: (value) => value!.isEmpty ? 'Inserisci il titolo' : null,
              ),
              TextFormField(
                // Collega il controller dell'importo.
                controller: _amountController,
                // Imposta l'etichetta del campo.
                decoration: const InputDecoration(labelText: 'Costo'),
                // Imposta la tastiera numerica.
                keyboardType: TextInputType.number,
                // Validazione del campo.
                validator: (value) => value!.isEmpty ? 'Inserisci il costo' : null,
              ),
              TextFormField(
                // Impedisce la modifica diretta del campo.
                readOnly: true,
                // Imposta l'etichetta del campo.
                decoration: const InputDecoration(labelText: 'Data'),
                // Chiama _selectDate quando il campo è toccato.
                onTap: _selectDate,
                // Mostra la data selezionata o un messaggio predefinito.
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                      : 'Nessuna data selezionata',
                ),
                // Validazione del campo.
                validator: (value) => _selectedDate == null ? 'Seleziona la data' : null,
              ),
              DropdownButtonFormField(
                // Imposta la categoria selezionata come valore.
                value: _selectedCategory,
                items: Categories().categories.map((category) {
                  return DropdownMenuItem(
                    // Imposta il valore dell'item.
                    value: category,
                    // Mostra il testo dell'item.
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // Aggiorna la categoria selezionata.
                    _selectedCategory = value.toString();
                  });
                },
                // Imposta l'etichetta del campo.
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // Collega il controller della nuova categoria.
                      controller: _categoryController,
                      // Imposta l'etichetta del campo.
                      decoration: const InputDecoration(labelText: 'Nuova Categoria'),
                    ),
                  ),
                  IconButton(
                    // Icona del pulsante.
                    icon: const Icon(Icons.add),
                    // Chiama _addCategory quando premuto.
                    onPressed: _addCategory,
                  ),
                ],
              ),
              ElevatedButton(
                // Chiama _saveExpense quando premuto.
                onPressed: _saveExpense,
                // Testo del pulsante.
                child: const Text('Salva spesa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
