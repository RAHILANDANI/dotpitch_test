import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

class UserViewModel {
  final Database database;

  UserViewModel(this.database);

  Future<List<User>> getUsers() async {
    final data = await database.query('users');
    return data.map((e) => User.fromMap(e)).toList();
  }

  Future<void> addUser(User user) async {
    await database.insert('users', user.toMap());
  }

  Future<void> deleteUser(int id) async {
    await database.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
