import 'package:flutter/material.dart';
import 'package:personal_finance/budget/budget.dart';
import 'package:personal_finance/budget/income.dart';
import 'package:personal_finance/home/home.dart';
import 'budget/expenses.dart';
import 'consts/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: ZoomPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'February, 2022'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentTab = 0;
  var tabs = [Routes.home, Routes.income, Routes.expenses, Routes.budget];
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_navigatorKey.currentState != null) {
            if (_navigatorKey.currentState!.canPop()) {
              _navigatorKey.currentState!.pop(context);
              return false;
            }
          }

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title),
              const Text("Home",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(150, 255, 255, 255)))
            ],
          )),
          drawer: Drawer(
              child: ListView(
            children: [
              for (var i = 2022; i > 2001; i--)
                ListTile(
                  title: Text("February $i"),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.green),
                  onTap: () {},
                ),
            ],
          )),
          body: Center(
              child: Navigator(
            key: _navigatorKey,
            initialRoute: "/",
            onGenerateRoute: _onGenerateRoute,
          )),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            onTap: (i) => {
              setState(() {
                currentTab = i;
                _navigatorKey.currentState!.pushNamed(tabs[i]);
              })
            },
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward),
                label: 'Income',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_graph),
                label: 'Budget',
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            onPressed: () => {},
            tooltip: 'Add Income or Expense',
            label: const Text("Add"),
            icon: const Icon(
              Icons.add,
              size: 28,
            ),
          ),
        ));
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page = const HomePage();

    switch (settings.name) {
      case Routes.home:
        page = const HomePage();
        break;
      case Routes.income:
        page = const IncomePage();
        break;
      case Routes.expenses:
        page = const ExpensesPage();
        break;
      case Routes.budget:
        page = const BudgetPage();
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
