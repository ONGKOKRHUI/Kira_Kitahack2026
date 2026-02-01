import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Current user stream
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
  
  // Current user
  User? get currentUser => _auth.currentUser;
  
  // User ID  
  String? get userId => _auth.currentUser?.uid;
  
  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In...');
      
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔐 User canceled sign-in');
        return null; // User canceled
      }
      
      print('🔐 Google user: ${googleUser.email}');
      
      // Get auth credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      print('🔐 Firebase sign-in successful: ${userCredential.user?.uid}');
      
      return userCredential.user;
    } catch (e) {
      print('🔐 Google Sign-In error: $e');
      return null;
    }
  }
  
  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      print('🔐 Starting Email Sign-In for: $email');
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('🔐 Email sign-in successful: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      print('🔐 Email Sign-In error: $e');
      rethrow; // Re-throw to show error message in UI
    }
  }
  
  /// Sign up with email and password
  /// 
  /// Security: Firebase handles password hashing and secure storage.
  /// The password is never stored in the app - only sent securely to Firebase
  /// servers where it's hashed and stored using industry-standard encryption.
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      print('🔐 Creating account for: $email');
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('🔐 Account created successfully: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      print('🔐 Sign-Up error: $e');
      rethrow; // Re-throw to show error message in UI
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    print('🔐 Signing out...');
    await _googleSignIn.signOut();
    await _auth.signOut();
    print('🔐 Sign out complete');
  }
  
  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;
}
