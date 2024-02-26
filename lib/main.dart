import 'package:flutter/material.dart';
import 'package:calculatorvtwo_app/AboutView.dart';
import 'package:calculatorvtwo_app/CalculatorView.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:calculatorvtwo_app/SignUpView.dart';
import 'package:calculatorvtwo_app/api/google_signin_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData? theme;

  const MyApp({Key? key, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkThemeProvider(),
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                themeProvider.darkTheme ? ThemeData.dark() : ThemeData.light(),
            home: SignUpScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _connectionStatus = 'Unknown';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _listenForConnectivityChanges();
  }

  Future<void> _initConnectivity() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      _connectionStatus = isConnected ? 'Connected' : 'Disconnected';
    });
  }

  void _listenForConnectivityChanges() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status == InternetConnectionStatus.connected
            ? 'Connected'
            : 'Disconnected';
      });
      _showConnectivitySnackbar();
    });
  }

  void _showConnectivitySnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_connectionStatus),
        duration: Duration(seconds: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('NavCalcApp'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16),
                  CircleAvatar(
                    radius: 30, // Adjust the radius as needed
                    backgroundImage: AssetImage(
                        'assets/default_avatar.jpg'), // Provide a default avatar image
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calculator(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contacts'),
              onTap: () {
                // Navigate to a screen or perform an action to access device contacts here
                // You can implement this based on your application's requirements
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await GoogleSignInApi.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Gikondo Mode'),
              trailing: Checkbox(
                value: themeChange.darkTheme,
                onChanged: (bool? value) {
                  if (value != null) {
                    themeChange.darkTheme = value;
                  }
                },
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to NavCalcApp!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Your All-in-One Calculator',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      child: Icon(Icons.home),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: CircleAvatar(
                      child: Icon(Icons.calculate),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  label: 'Calculator',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: CircleAvatar(
                      child: Icon(Icons.info),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  label: 'About Us',
                ),
              ],
              selectedItemColor: Colors.blue,
              onTap: (int index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Calculator(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(),
                    ),
                  );
                }
              },
            ),
            body: Center(),
          ),
        ],
      ),
    );
  }
}

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    notifyListeners();
  }
}
