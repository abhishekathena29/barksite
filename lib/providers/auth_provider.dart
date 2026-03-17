import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({fb_auth.FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? fb_auth.FirebaseAuth.instance,
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

  User _buildUserFromFirebaseUser(fb_auth.User fbUser, {String? createdAt}) {
    return User(
      id: fbUser.uid,
      name: fbUser.displayName ?? '',
      email: fbUser.email ?? '',
      createdAt: createdAt ?? DateTime.now().toIso8601String(),
    );
  }

  Future<bool> _waitForCurrentUser(String uid) async {
    const timeout = Duration(seconds: 10);
    const pollInterval = Duration(milliseconds: 100);
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      if (!_loading && _currentUser?.id == uid) {
        return true;
      }
      await Future<void>.delayed(pollInterval);
    }

    return !_loading && _currentUser?.id == uid;
  }

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
        final user = _buildUserFromFirebaseUser(fbUser);
        await _firestore.collection('users').doc(fbUser.uid).set(user.toJson());
        _currentUser = user;
      }
    } catch (e) {
      _currentUser = _buildUserFromFirebaseUser(fbUser);
      _error = 'Signed in, but profile sync failed';
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
      await cred.user?.reload();

      final user = _buildUserFromFirebaseUser(_auth.currentUser ?? cred.user!);

      try {
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } catch (_) {
        _error = 'Account created, but profile sync failed';
      }

      _currentUser = user;
      _loading = false;
      notifyListeners();

      return await _waitForCurrentUser(cred.user!.uid);
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
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _loading = false;
      notifyListeners();

      final isReady = await _waitForCurrentUser(cred.user!.uid);
      if (!isReady) {
        _error = 'Login succeeded, but profile loading timed out';
        notifyListeners();
      }
      return isReady;
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

  Future<bool> updateProfile({
    required String name,
    required String city,
    required String bio,
  }) async {
    final user = _auth.currentUser;
    final currentUser = _currentUser;
    if (user == null || currentUser == null) return false;

    final updatedUser = currentUser.copyWith(
      name: name,
      city: city,
      bio: bio,
      updatedAt: DateTime.now().toIso8601String(),
    );

    try {
      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(user.uid).set(
            updatedUser.toJson(),
            SetOptions(merge: true),
          );
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Failed to update profile';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateSelectedDog(String? dogId) async {
    final user = _currentUser;
    if (user == null || user.selectedDogId == dogId) return;

    _currentUser = user.copyWith(
      selectedDogId: dogId,
      clearSelectedDogId: dogId == null,
      updatedAt: DateTime.now().toIso8601String(),
    );
    notifyListeners();

    try {
      await _firestore.collection('users').doc(user.id).set(
            {
              'selectedDogId': dogId,
              'updatedAt': DateTime.now().toIso8601String(),
            },
            SetOptions(merge: true),
          );
    } catch (_) {
      _error = 'Failed to save selected dog';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
