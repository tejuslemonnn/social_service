import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_service/models/service_model.dart';

import 'impl_service_repository.dart';

class ServiceRepository extends ImplServiceRepository {
  final FirebaseFirestore _firebaseFirestore;

  ServiceRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Service>> getAllServices() {
    return _firebaseFirestore.collection('services').snapshots().map(
          (event) =>
              event.docs.map((docs) => Service.fromSnapshop(docs)).toList(),
        );
  }
}
