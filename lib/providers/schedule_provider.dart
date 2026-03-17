import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/schedule_item.dart';
import 'auth_provider.dart';
import 'dog_provider.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider(this._authProvider, this._dogProvider, {FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance {
    _authProvider.addListener(_onDependenciesChanged);
    _dogProvider.addListener(_onDependenciesChanged);
    _onDependenciesChanged();
  }

  final AuthProvider _authProvider;
  final DogProvider _dogProvider;
  final FirebaseFirestore _firestore;

  List<ScheduleItem> _items = [];
  bool _loading = false;
  String? _error;
  String? _activeUserId;
  String? _activeDogId;

  List<ScheduleItem> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _itemsSub;

  Future<void> _onDependenciesChanged() async {
    final userId = _authProvider.currentUser?.id;
    final dogId = _dogProvider.selectedDog?.id;

    if (_activeUserId == userId && _activeDogId == dogId) {
      return;
    }

    _activeUserId = userId;
    _activeDogId = dogId;
    await _itemsSub?.cancel();
    _itemsSub = null;
    _items = [];
    _error = null;

    if (userId == null || dogId == null) {
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    _itemsSub = _firestore
        .collection('users')
        .doc(userId)
        .collection('dogs')
        .doc(dogId)
        .collection('schedule')
        .orderBy('dateTime')
        .snapshots()
        .listen(
          (snapshot) {
            _items = snapshot.docs.map((doc) => ScheduleItem.fromJson(doc.data())).toList();
            _loading = false;
            notifyListeners();
          },
          onError: (_) {
            _error = 'Failed to load schedule';
            _loading = false;
            notifyListeners();
          },
        );
  }

  List<ScheduleItem> itemsForDay(DateTime day) {
    return _items.where((item) {
      final itemDate = item.startsAt;
      return itemDate.year == day.year &&
          itemDate.month == day.month &&
          itemDate.day == day.day;
    }).toList();
  }

  List<ScheduleItem> upcomingItems({int limit = 3}) {
    final now = DateTime.now();
    final upcoming = _items.where((item) => !item.isCompleted && item.startsAt.isAfter(now)).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return upcoming.take(limit).toList();
  }

  Future<bool> addItem(ScheduleItem item) async {
    final userId = _authProvider.currentUser?.id;
    final dogId = _dogProvider.selectedDog?.id;
    if (userId == null || dogId == null) {
      _error = 'Select a dog before adding a schedule';
      notifyListeners();
      return false;
    }

    try {
      final doc = _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .collection('schedule')
          .doc();
      final created = item.copyWith(
        id: doc.id,
        createdAt: DateTime.now().toIso8601String(),
      );
      await doc.set(created.toJson());
      return true;
    } catch (_) {
      _error = 'Failed to save schedule';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleCompleted(ScheduleItem item) async {
    final userId = _authProvider.currentUser?.id;
    final dogId = _dogProvider.selectedDog?.id;
    if (userId == null || dogId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .collection('schedule')
          .doc(item.id)
          .set({'isCompleted': !item.isCompleted}, SetOptions(merge: true));
      return true;
    } catch (_) {
      _error = 'Failed to update schedule';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    final userId = _authProvider.currentUser?.id;
    final dogId = _dogProvider.selectedDog?.id;
    if (userId == null || dogId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .collection('schedule')
          .doc(itemId)
          .delete();
      return true;
    } catch (_) {
      _error = 'Failed to delete schedule';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _itemsSub?.cancel();
    _authProvider.removeListener(_onDependenciesChanged);
    _dogProvider.removeListener(_onDependenciesChanged);
    super.dispose();
  }
}
