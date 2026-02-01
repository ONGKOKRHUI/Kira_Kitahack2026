import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get user profile
  Future<UserProfile?> getProfile(String uid) async {
    try {
      print('👤 Fetching profile for user: $uid');
      
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        print('👤 No profile found for user: $uid');
        return null;
      }
      
      print('👤 Profile found: ${doc.data()?['companyName']}');
      return UserProfile.fromFirestore(doc.data()!);
    } catch (e) {
      print('👤 Error fetching profile: $e');
      return null;
    }
  }
  
  // Save user profile
  Future<void> saveProfile(UserProfile profile) async {
    try {
      print('👤 Saving profile for: ${profile.email}');
      
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toJson());
      
      print('👤 Profile saved successfully');
    } catch (e) {
      print('👤 Error saving profile: $e');
      rethrow;
    }
  }
  
  // Update company details
  Future<void> updateCompanyDetails(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      print('👤 Updating company details for: $uid');
      
      await _firestore.collection('users').doc(uid).update({
        ...updates,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      print('👤 Company details updated');
    } catch (e) {
      print('👤 Error updating company details: $e');
      rethrow;
    }
  }
  
  // Stream user profile
  Stream<UserProfile?> streamProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserProfile.fromFirestore(doc.data()!);
        });
  }
}
