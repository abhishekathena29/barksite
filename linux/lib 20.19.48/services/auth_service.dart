import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/dog_profile.dart';
import '../models/user.dart';

class AuthService {
  static const String _usersKey = 'barksite_users';
  static const String _currentUserKey = 'barksite_current_user';
  static const String _dogsKey = 'barksite_dogs';

  static Future<List<User>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  static String _dogsKeyForUser(String userId) => '${_dogsKey}_$userId';

  static String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();

  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final users = await _getUsers();
    final exists = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) {
      return {'success': false, 'error': 'An account with this email already exists'};
    }
    final newUser = User(
      id: _generateId(),
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now().toIso8601String(),
    );
    users.add(newUser);
    await _saveUsers(users);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(newUser.toJson()));
    return {'success': true};
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final users = await _getUsers();
    final user = users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      orElse: () => User(
        id: '',
        name: '',
        email: '',
        password: '',
        createdAt: '',
      ),
    );
    if (user.id.isEmpty) {
      return {'success': false, 'error': 'Invalid email or password'};
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    return {'success': true};
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);
    if (data == null) return null;
    return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  static Future<List<DogProfile>> getUserDogs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_dogsKeyForUser(userId));
    if (data == null) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map((e) => DogProfile.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<DogProfile> addDog(String userId, DogProfile dog) async {
    final dogs = await getUserDogs(userId);
    final newDog = DogProfile(
      id: _generateId(),
      name: dog.name,
      breed: dog.breed,
      age: dog.age,
      weight: dog.weight,
      activityLevel: dog.activityLevel,
      healthConditions: dog.healthConditions,
    );
    dogs.add(newDog);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dogsKeyForUser(userId), jsonEncode(dogs.map((d) => d.toJson()).toList()));
    return newDog;
  }

  static Future<void> deleteDog(String userId, String dogId) async {
    final dogs = await getUserDogs(userId);
    final updated = dogs.where((d) => d.id != dogId).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dogsKeyForUser(userId), jsonEncode(updated.map((d) => d.toJson()).toList()));
  }
}
