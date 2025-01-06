
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:untitled/third_page.dart';
import 'package:untitled/viewmodel/user_view_model.dart';

import '../models/user_model.dart';
import 'add_page.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late UserViewModel _userViewModel;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    final database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, email TEXT, phoneNumber TEXT, address TEXT)',
        );
      },
      version: 1,
    );
    _userViewModel = UserViewModel(database);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userViewModel.getUsers();
    setState(() => _users = users);
  }

  Future<void> _deleteUser(int id) async {
    await _userViewModel.deleteUser(id);
    _loadUsers();
  }

  void _navigateToAddPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(
          userViewModel: _userViewModel, // Pass the existing UserViewModel instance
          onSave: _loadUsers, // Callback function to reload users after saving
        ),
      ),
    );
  }


  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        leading: IconButton(
          icon: const Icon(Icons.apps),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ThirdPage()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:(){
              _logout(context);
            },
          ),
        ],
      ),
      body: _users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Slidable(
            key: ValueKey(user.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _deleteUser(user.id!),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text("${user.firstName} ${user.lastName}"),
              subtitle: Text(user.email),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _navigateToAddPage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
