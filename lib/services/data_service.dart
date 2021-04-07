import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/models/weight_model.dart';

class DataService {
  Future<bool> addWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    try {
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('weights')
          .add((model.toJson()));
    } catch (exception) {
      return false;
    }
    return true;
  }

  Future<bool> editWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    try {
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('weights')
          .doc(model.id)
          .update(model.toJson());
    } catch (exception) {
      return false;
    }
    return true;
  }

  Future<bool> removeWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    try {
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('weights')
          .doc(model.id)
          .delete();
    } catch (exception) {
      return false;
    }

    return true;
  }

  Stream<List<WeightModel>> entriesStream() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    try {
      return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('weights')
          .orderBy('time', descending: true)
          .snapshots()
          .map((event) {
        return event.docs
            .map((e) => WeightModel.fromFirestore(e.data()!, e.id))
            .toList();
      });
    } catch (exception) {
      return Stream.empty();
    }
  }
}
