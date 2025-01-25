class Categories {
  /*
    Costruttore privato nominato `Categories`.
    Questo costruttore è utilizzato internamente all'interno della classe per creare istanze di `Categories`. 
    Non può essere accessibile o chiamato dall'esterno della classe, 
    garantendo che l'istanza di `Categories` sia controllata e limitata.
  */
  static final Categories _instance = Categories._internal();
  factory Categories() => _instance;

  Categories._internal();

  List<String> categories = [
    'Cibo',
    'Trasporto',
    'Bollette',
    'Sanità',
    'Tempo libero'
  ];

  void addCategory(String category) {
    if (!categories.contains(category)) {
      categories.add(category);
    }
  }
}
