import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/models/weight_model.dart';

class DataService {
  Future<List<WeightModel>> entries() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final doc = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('weights')
        .orderBy('time', descending: true)
        .get();

    return doc.docs.map((element) {
      WeightModel model =
          WeightModel.fromFirestore(element.data()!, element.id);
      return model;
    }).toList();
  }

  Future<bool> addWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('weights')
        .add((model.toJson()));
    return true;
  }

  Future<bool> editWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('weights')
        .doc(model.id)
        .update(model.toJson());
    return true;
  }

  Future<bool> removeWeightEntry(WeightModel model) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('weights')
        .doc(model.id)
        .delete();
    return true;
  }

  Stream<List<WeightModel>> entriesStream() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
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
  }
}
