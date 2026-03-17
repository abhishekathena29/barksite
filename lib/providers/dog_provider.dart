import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/dog_profile.dart';
import 'auth_provider.dart';

class DogProvider extends ChangeNotifier {
  DogProvider(this._authProvider, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _authProvider.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  final AuthProvider _authProvider;
  final FirebaseFirestore _firestore;

  List<DogProfile> _dogs = [];
  bool _loading = false;
  String? _error;

  List<DogProfile> get dogs => _dogs;
  bool get loading => _loading;
  String? get error => _error;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _dogsSub;
  Future<void> _onAuthChanged() async {
    await _dogsSub?.cancel();
    _dogs = [];
    _error = null;

    final user = _authProvider.currentUser;
    if (user == null) {
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    _dogsSub = _firestore
        .collection('users')
        .doc(user.id)
        .collection('dogs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _dogs = snapshot.docs
            .map((doc) => DogProfile.fromJson(doc.data()))
            .toList();
        _loading = false;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Failed to load dogs';
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<DogProfile?> addDog(DogProfile dog) async {
    final user = _authProvider.currentUser;
    if (user == null) {
      _error = 'Please log in first';
      notifyListeners();
      return null;
    }

    try {
      final doc = _firestore.collection('users').doc(user.id).collection('dogs').doc();
      final newDog = DogProfile(
        id: doc.id,
        name: dog.name,
        breed: dog.breed,
        age: dog.age,
        weight: dog.weight,
        activityLevel: dog.activityLevel,
        healthConditions: dog.healthConditions,
      );
      await doc.set({
        ...newDog.toJson(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      return newDog;
    } catch (_) {
      _error = 'Failed to add dog';
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteDog(String dogId) async {
    final user = _authProvider.currentUser;
    if (user == null) return;
    try {
      await _firestore.collection('users').doc(user.id).collection('dogs').doc(dogId).delete();
    } catch (_) {
      _error = 'Failed to delete dog';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _dogsSub?.cancel();
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }
}
