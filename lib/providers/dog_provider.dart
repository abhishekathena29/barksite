import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/dog_profile.dart';
import 'auth_provider.dart';

class DogProvider extends ChangeNotifier {
  DogProvider(this._authProvider, {FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance {
    _authProvider.addListener(_onAuthStateChanged);
    _onAuthStateChanged();
  }

  final AuthProvider _authProvider;
  final FirebaseFirestore _firestore;

  List<DogProfile> _dogs = [];
  bool _loading = false;
  String? _error;
  String? _activeUserId;
  String? _selectedDogId;

  List<DogProfile> get dogs => _dogs;
  bool get loading => _loading;
  String? get error => _error;
  String? get selectedDogId => _selectedDogId;
  DogProfile? get selectedDog {
    if (_selectedDogId == null) {
      return _dogs.isEmpty ? null : _dogs.first;
    }

    for (final dog in _dogs) {
      if (dog.id == _selectedDogId) {
        return dog;
      }
    }

    return _dogs.isEmpty ? null : _dogs.first;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _dogsSub;

  Future<void> _onAuthStateChanged() async {
    final user = _authProvider.currentUser;
    final userId = user?.id;

    if (_activeUserId == userId) {
      if (user != null && user.selectedDogId != _selectedDogId) {
        _syncSelectedDog(
          preferredDogId: user.selectedDogId,
          persistSelection: false,
        );
      }
      return;
    }

    _activeUserId = userId;
    await _dogsSub?.cancel();
    _dogsSub = null;
    _dogs = [];
    _error = null;
    _selectedDogId = user?.selectedDogId;

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
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            _dogs = snapshot.docs
                .map((doc) => DogProfile.fromJson(doc.data()))
                .toList();
            _loading = false;
            _syncSelectedDog(
              preferredDogId: user.selectedDogId,
              persistSelection: true,
            );
          },
          onError: (_) {
            _error = 'Failed to load dogs';
            _loading = false;
            notifyListeners();
          },
        );
  }

  void _syncSelectedDog({
    String? preferredDogId,
    required bool persistSelection,
  }) {
    String? nextSelectedDogId;

    if (preferredDogId != null &&
        _dogs.any((dog) => dog.id == preferredDogId)) {
      nextSelectedDogId = preferredDogId;
    } else if (_dogs.isNotEmpty) {
      nextSelectedDogId = _dogs.first.id;
    }

    final selectionChanged = nextSelectedDogId != _selectedDogId;
    _selectedDogId = nextSelectedDogId;
    notifyListeners();

    if (persistSelection && selectionChanged) {
      unawaited(_authProvider.updateSelectedDog(nextSelectedDogId));
    }
  }

  Future<void> selectDog(String dogId) async {
    if (!_dogs.any((dog) => dog.id == dogId)) return;
    _selectedDogId = dogId;
    notifyListeners();
    await _authProvider.updateSelectedDog(dogId);
  }

  Future<DogProfile?> addDog(DogProfile dog) async {
    final user = _authProvider.currentUser;
    if (user == null) {
      _error = 'Please log in first';
      notifyListeners();
      return null;
    }

    try {
      final doc = _firestore
          .collection('users')
          .doc(user.id)
          .collection('dogs')
          .doc();
      final newDog = dog.copyWith(
        id: doc.id,
        createdAt: DateTime.now().toIso8601String(),
      );
      await doc.set(newDog.toJson());

      _dogs = [..._dogs, newDog]
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _selectedDogId = newDog.id;
      _error = null;
      notifyListeners();

      await _authProvider.updateSelectedDog(newDog.id);
      return newDog;
    } catch (_) {
      _error = 'Failed to add dog';
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateDog(DogProfile dog) async {
    final user = _authProvider.currentUser;
    if (user == null) {
      _error = 'Please log in first';
      notifyListeners();
      return false;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dogs')
          .doc(dog.id)
          .set(dog.toJson(), SetOptions(merge: true));
      return true;
    } catch (_) {
      _error = 'Failed to update dog';
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteDog(String dogId) async {
    final user = _authProvider.currentUser;
    if (user == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dogs')
          .doc(dogId)
          .delete();
      if (_selectedDogId == dogId) {
        await _authProvider.updateSelectedDog(null);
      }
    } catch (_) {
      _error = 'Failed to delete dog';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _dogsSub?.cancel();
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
