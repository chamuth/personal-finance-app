import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/budget/budget.dart';
import 'package:personal_finance/budget/income_expense.dart';
import 'package:personal_finance/home/home.dart';
import 'consts/routes.dart';
import 'database/database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'shared/adder.dart';
import 'store/model.dart';
import 'store/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create database
  await DB.initialize();

  var now = DateTime.now();
  final store = Store<AppStore>(AppStore.reducer,
      initialState: AppStore([], [], Timeframe(now.year, now.month)));

  loadData(store, Timeframe(now.year, now.month));

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

  runApp(MyApp(store: store));
}

void loadData(Store<AppStore> store, Timeframe tf) async {
  var categories = await Category.all(DB.database!, tf);
  store.dispatch(DispatchType(AppStoreActions.updateCategories, categories));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);
  final Store<AppStore> store;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Personal Finance App',
          theme: ThemeData(
            primarySwatch: Colors.green,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Personal Finance App'),
        ));
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
  var tabTitles = ["Home", "Income", "Expense", "Budget"];
  final _navigatorKey = GlobalKey<NavigatorState>();

  int createSelectionType = 0;

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
        child: StoreConnector<AppStore, Timeframe>(
            converter: (store) => store.state.timeframe,
            builder: (context, tf) => Scaffold(
                  appBar: AppBar(
                      title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat("MMMM, y")
                          .format(DateTime(tf.year, tf.month))),
                      Text(tabTitles[currentTab],
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(150, 255, 255, 255)))
                    ],
                  )),
                  drawer: Drawer(
                    backgroundColor: const Color.fromARGB(255, 220, 250, 220),
                    child: StoreConnector<AppStore, Function(Timeframe)>(
                      converter: (store) => ((Timeframe tf) {
                        store.dispatch(DispatchType(AppStoreActions.updateTimeFrame, tf));
                        loadData(store, tf);
                      }),
                      builder: (context, dispatch) => ListView(
                        children: [
                          DrawerHeader(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Selected month"),
                                Text(
                                  DateFormat("MMMM, y")
                                      .format(DateTime(tf.year, tf.month)),
                                  style: const TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 220, 250, 220),
                            ),
                          ),
                          for (var i = DateTime.now().month; i > 1; i--)
                            ListTile(
                              title: Text(DateFormat("MMMM, y")
                                  .format(DateTime(tf.year, i))),
                              trailing: const Icon(Icons.arrow_forward,
                                  color: Colors.green),
                              onTap: () => dispatch(Timeframe(tf.year, i)),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                        if (currentTab != i) {
                          currentTab = i;
                          _navigatorKey.currentState!.pushNamed(tabs[i]);
                        }

                        if (i == 1) {
                          setState(() {
                            createSelectionType = 0;
                          });
                        }

                        if (i == 2) {
                          setState(() {
                            createSelectionType = 1;
                          });
                        }
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
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    onPressed: () => StatementAdder.addStatement(
                        context, createSelectionType),
                    tooltip: 'Add Income or Expense',
                    label: const Text("Add"),
                    icon: const Icon(
                      Icons.add,
                      size: 28,
                    ),
                  ),
                )));
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page = const HomePage();

    switch (settings.name) {
      case Routes.home:
        page = const HomePage();
        break;
      case Routes.income:
        page = const IncomeExpensePage(mode: IncomeExpense.income);
        break;
      case Routes.expenses:
        page = const IncomeExpensePage(mode: IncomeExpense.expense);
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
