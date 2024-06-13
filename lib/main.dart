import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/counter/app.dart';
import 'package:flutter_application_1/counter/counter.dart';
import 'package:flutter_application_1/counter_observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Aplikasi",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 54, 26, 157)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  var history = <WordPair>[];

  void toggleFavorit(){
    if(favorites.contains(current)){
      favorites.remove(current);
    } else{
      favorites.add(current);
    }
    notifyListeners();
  }

    void toggleHistory(){
    if(history.contains(current)){
      history.remove(current);
    } else{
      history.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex = 0;

  @override

  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex){
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const FavoritePage();
        case 2:
        page = const History();
        case 3:
        page = const CounteraApp();
      default:
        page = const Placeholder();
    }
    
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value){
          setState((){
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home'),
          NavigationDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_border_outlined),
              label: 'Favorite'),
          NavigationDestination(
              icon: Icon(Icons.history_outlined),
              label: 'History'),
          NavigationDestination(
              icon: Icon(Icons.countertops_sharp),
              label: 'Counter'),
        ],
      ),
      body: Container(child: page),
    );
  }
}

class GeneratorPage extends StatelessWidget{
  const GeneratorPage({
    super.key
  });

 @override
  
 Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                 image: AssetImage("assets/dancing-monkey.gif"), fit: BoxFit.none)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Good morning!"),
              const Text("I am depressed"),
              BigCard(pair: pair),
              // ElevatedButton(
              //   onPressed: () {
              //     appState.getNext();
              //     print("button pressed");
              //   },
              //   child: const Text("Join Me"),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorit();

                  ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Fav/UnFav word ${appState.current}'),
                  ),
                  );
                },
                icon: Icon(icon),
                label: const Text("Favorite"),
                ),
              
              SizedBox(width:12),
              ElevatedButton(
                onPressed:(){
                  appState.getNext();
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ]),
      ),
    );}
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 20,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    );

    return Card(
      color: const Color.fromARGB(255, 220, 233, 255),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pair.asLowerCase,
          style: style,
        ),
      ),
    );
  }
}
class FavoritePage extends StatelessWidget{
  const FavoritePage({super.key});

  Widget build(BuildContext context){

    var appState = context.watch<MyAppState>();
    return Container(
      child: ListView(
        children: [
          Text("Favorite words: ${appState.favorites.length}"),
          ...appState.favorites.map(
            (wp) => ListTile(
              title: Text(wp.asCamelCase),
            )
          )
        ],
      ),
    );
  }
}
class History extends StatelessWidget{
  const History({super.key});

  Widget build(BuildContext context){

    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('History'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("History of Words(${appState.history.length}words):",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...appState.history.asMap().entries.map(
                  (entry) {
                    int index = entry.key + 1;
                    WordPair wordPair = entry.value;
                    return ListTile(
                      leading: CircleAvatar(child: Text('$index'),
                      ),
                    title: Text(wordPair.asCamelCase),
                    onTap: () {
                      ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.amber[200],content: Text(
                            'its word: ${wordPair.asCamelCase}!',
                            style: TextStyle(color: Colors.black),
                          )
                        ));
                    },
                    );
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );}}