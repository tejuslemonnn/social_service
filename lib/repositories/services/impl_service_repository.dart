import 'package:social_service/models/service_model.dart';

abstract class ImplServiceRepository {
  Stream<List<Service>> getAllServices();
}
