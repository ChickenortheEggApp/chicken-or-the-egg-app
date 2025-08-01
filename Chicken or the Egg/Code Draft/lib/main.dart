import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_coop_screen.dart';
import 'tabbed_coop_view.dart';
import 'coop_lineage_tab_view.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChickenOrTheEggApp());
}

class ChickenOrTheEggApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicken or the Egg',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange[700],
          foregroundColor: Colors.white,
        ),
      ),
      home: AuthWrapper(),
      routes: {
        '/create-coop': (context) => CreateCoopScreen(),
        '/coops': (context) => TabbedCoopView(),
        '/lineage': (context) => CoopLineageTabView(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Loading...', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }
        
        if (snapshot.hasData) {
          return HomeScreen();
        }
        
        return LoginScreen();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐔 Chicken or the Egg'),
        actions: [
          // User info
          if (!AuthService.isAnonymous())
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  'Hello, ${AuthService.getUserDisplayName()}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          // Account upgrade button for anonymous users
          if (AuthService.isAnonymous())
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.linkWithGoogle();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account upgraded successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upgrade account')),
                  );
                }
              },
              child: Text('Upgrade Account', style: TextStyle(color: Colors.white)),
            ),
          // Sign out button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.pets, size: 60, color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to your Chicken Empire!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your coops, track lineages, and grow your flock.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.add_home),
              label: Text('Create New Coop'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () => Navigator.pushNamed(context, '/create-coop'),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.dashboard),
              label: Text('View My Coops'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () => Navigator.pushNamed(context, '/coops'),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.account_tree),
              label: Text('Lineage Trees'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () => Navigator.pushNamed(context, '/lineage'),
            ),
          ],
        ),
      ),
    );
  }
}
