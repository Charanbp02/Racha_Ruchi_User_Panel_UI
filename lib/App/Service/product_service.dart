import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get products => firestore.collection('products');
}
