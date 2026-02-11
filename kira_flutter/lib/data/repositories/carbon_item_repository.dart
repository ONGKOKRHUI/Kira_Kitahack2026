import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kira_app/data/models/carbon_item.dart';

class CarbonItemRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // add a carbonItem to user
  Future<void> addCarbonItem(CarbonItem carbonItem, String userId) async {
    print('⛽ Uploading carbonItem for user: $userId');

    await firestore
      .collection('users')
      .doc(userId)
      .collection('carbonItems')
      .doc(carbonItem.id)
      .set(carbonItem.toJson());
      
    print('✅ Uploaded: ${carbonItem.name} - RM${carbonItem.price.toStringAsFixed(2)}');
  }

// get all carbonItems from a user
  Future<List<CarbonItem>> getCarbonItems(String userId) async{
    try {
      final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('carbonItems')
        .orderBy('date', descending: true)
        .get();

      final carbonItems = snapshot.docs
        .map((doc) => CarbonItem.fromJson(doc.data()))
        .toList();

      return carbonItems;
    } catch (e) {
      print('Error fetching carbonItems from $userId: $e');
      rethrow;
    }
  }

  // get only 1 specific carbonItem from a user
  Future<CarbonItem> getCarbonItem(String carbonItemId, String userId) async{
    try {
      final carbonItem = await firestore
        .collection('users')
        .doc(userId)
        .collection('carbonItems')
        .doc(carbonItemId)
        .get();

      if (!carbonItem.exists) {
        throw Exception('CarbonItem: $carbonItemId not found from user: $userId');
      }

      print('🫳Get carbonItem: $carbonItemId for user: $userId succesfully');
      return CarbonItem.fromJson(carbonItem.data()!);
    } catch (e) {
      print('Error fetching carbonItem $carbonItemId: $e');
      rethrow;
    }
  }

  // delete a carbonItem from a user
  Future<void> deleteCarbonItem(String carbonItemId, String userId) async {
    try {
      await firestore
        .collection('users')
        .doc(userId)
        .collection('carbonItems')
        .doc(carbonItemId)
        .delete();

      print('🗑️ Cleared carbonItem: $carbonItemId for user: $userId');
    }catch (e) {
      print('Error deleting carbonItem $carbonItemId: $e');
      rethrow;
    }
  }
}
