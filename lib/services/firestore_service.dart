import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paradise/models/destination.dart';

abstract class BaseFirestoreService{
  Future<DocumentReference> addDestination(Destination destination);
  Future<List<Destination>> getListDestination();
}

class FirestoreService implements BaseFirestoreService{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  @override
  Future<DocumentReference> addDestination(Destination destination) async{
    Map map=destination.map;
    map.removeWhere((key, value) => key==null || value==null);
   var result= await firestore.collection('destination').add(map);
   return result;
  }

  @override
  Future<List<Destination>> getListDestination() async{
      List<Destination> list= [];
      QuerySnapshot result=await firestore.collection('destination').get();
      result.docs.forEach((element) {
        Destination destination=Destination.fromJson(element.data());
        destination.ref=element.reference;
        list.add(destination);
      });
   return list;
  }

  

}