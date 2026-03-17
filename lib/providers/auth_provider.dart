import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    fb_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? _currentUser;
  bool _loading = true;
  String? _error;

  Stream<fb_auth.User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  String? get error => _error;

  late final StreamSubscription<fb_auth.User?> _authSub;

  Future<void> _onAuthChanged(fb_auth.User? fbUser) async {
    _loading = true;
    _error = null;
    notifyListeners();

    if (fbUser == null) {
      _currentUser = null;
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists) {
        _currentUser = User.fromJson(doc.data()!);
      } else {
        final now = DateTime.now().toIso8601String();
        final user = User(
          id: fbUser.uid,
          name: fbUser.displayName ?? '',
          email: fbUser.email ?? '',
          createdAt: now,
        );
        await _firestore.collection('users').doc(fbUser.uid).set(user.toJson());
        _currentUser = user;
      }
    } catch (e) {
      _error = 'Failed to load profile';
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> signUp(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      final now = DateTime.now().toIso8601String();
      final user = User(
        id: cred.user!.uid,
        name: name,
        email: email,
        createdAt: now,
      );
      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      _currentUser = user;
      _loading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Signup failed';
    } catch (_) {
      _error = 'Signup failed';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _loading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Login failed';
    } catch (_) {
      _error = 'Login failed';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
