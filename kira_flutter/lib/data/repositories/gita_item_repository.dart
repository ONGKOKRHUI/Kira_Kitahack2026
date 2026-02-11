import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kira_app/data/models/gita_item.dart';

class GitaItemRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // add a gitaItem to user
  Future<void> addGitaItem(GitaItem gitaItem, String userId) async {
    print('🌳 Uploading gitaItem for user: $userId');

    await firestore
      .collection('users')
      .doc(userId)
      .collection('gitaItems')
      .doc(gitaItem.id)
      .set(gitaItem.toJson());
      
    print('✅ Uploaded: ${gitaItem.name} - RM${gitaItem.price.toStringAsFixed(2)}');
  }

// get all gitaItems from a user
  Future<List<GitaItem>> getGitaItems(String userId) async{
    try {
      final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('gitaItems')
        .orderBy('date', descending: true)
        .get();

      final gitaItems = snapshot.docs
        .map((doc) => GitaItem.fromJson(doc.data()))
        .toList();

      return gitaItems;
    } catch (e) {
      print('Error fetching gitaItems from $userId: $e');
      rethrow;
    }
  }

  // get only 1 specific gitaItem from a user
  Future<GitaItem> getGitaItem(String gitaItemId, String userId) async{
    try {
      final gitaItem = await firestore
        .collection('users')
        .doc(userId)
        .collection('gitaItems')
        .doc(gitaItemId)
        .get();

      if (!gitaItem.exists) {
        throw Exception('GitaItem: $gitaItemId not found from user: $userId');
      }

      print('🫳Get gitaItem: $gitaItemId for user: $userId succesfully');
      return GitaItem.fromJson(gitaItem.data()!);
    } catch (e) {
      print('Error fetching gitaItem $gitaItemId: $e');
      rethrow;
    }
  }

  // delete a gitaItem from a user
  Future<void> deleteGitaItem(String gitaItemId, String userId) async {
    try {
      await firestore
        .collection('users')
        .doc(userId)
        .collection('gitaItems')
        .doc(gitaItemId)
        .delete();

      print('🗑️ Cleared gitaItem: $gitaItemId for user: $userId');
    }catch (e) {
      print('Error deleting gitaItem $gitaItemId: $e');
      rethrow;
    }
  }
}